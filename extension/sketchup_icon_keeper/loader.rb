require 'open3'
require 'securerandom'
require 'tmpdir'

module SketchUpIconKeeper
  module_function

  def helper_path
    File.join(__dir__, 'set_finder_icon.js')
  end

  def worker_path
    File.join(__dir__, 'repair_sketchup_icons.py')
  end

  def install
    @observed_models ||= {}
    attach_model(Sketchup.active_model)
    @app_observer ||= AppObserver.new
    Sketchup.add_observer(@app_observer)
    add_menu
  end

  def attach_model(model)
    return unless model
    return if @observed_models[model.object_id]

    observer = SavedModelObserver.new
    model.add_observer(observer)
    @observed_models[model.object_id] = observer
  end

  def add_menu
    return if @menu_added

    UI.menu('Extensions').add_item('Repair current SketchUp Finder icon') do
      refresh(Sketchup.active_model.path)
    end
    UI.menu('Extensions').add_item('Repair a folder of SketchUp Finder icons…') do
      repair_folder
    end
    @menu_added = true
  end

  def queue_refresh(path)
    return unless skp_path?(path)
    @queued_paths ||= {}
    return if @queued_paths[path]

    @queued_paths[path] = true
    UI.start_timer(0.5, false) do
      refresh(path)
      @queued_paths.delete(path)
    end
  end

  def refresh(path)
    return unless skp_path?(path)
    return unless File.file?(path)

    original = File.stat(path)
    thumbnail = File.join(Dir.tmpdir, "sketchup-icon-#{SecureRandom.hex(12)}.png")
    # Current SKP files prepend a small VFF header to their ZIP archive.
    # macOS unzip emits a warning (and exits 1) for that harmless prefix even
    # though it successfully writes the embedded PNG.  The PNG signature is
    # the meaningful validity check, not unzip's exit status.
    output, _diagnostic, _status = Open3.capture3('/usr/bin/unzip', '-p', path, 'meta/model_thumbnail.png')
    return unless output.b.start_with?("\x89PNG\r\n\x1a\n".b)

    File.binwrite(thumbnail, output)
    _output, diagnostic, status = Open3.capture3(
      '/usr/bin/osascript', '-l', 'JavaScript', helper_path, thumbnail, path
    )
    puts "Mac SKP Icon Repair & Keeper: #{diagnostic}" unless status.success?
    File.utime(original.atime, original.mtime, path)
  rescue StandardError => error
    puts "SketchUp Icon Keeper: #{error.message}"
  ensure
    File.delete(thumbnail) if thumbnail && File.exist?(thumbnail)
  end

  def repair_folder
    if @repair_pid && process_running?(@repair_pid)
      UI.messagebox('A folder repair is already running. Its progress is in the DeleteMe report in the selected folder.')
      return
    end

    folder = UI.select_directory(title: 'Choose a SketchUp model folder to repair')
    return unless folder

    expanded = File.expand_path(folder)
    if unsafe_folder?(expanded)
      UI.messagebox('Please choose a project, user, or model-library folder rather than the whole disk or a system folder.')
      return
    end

    python = '/usr/bin/python3'
    unless File.executable?(python)
      UI.messagebox('Folder repair requires Python 3 at /usr/bin/python3. The current-model repair remains available.')
      return
    end

    report = File.join(expanded, 'SketchUp Icon Repair - DeleteMe.txt')
    File.open(report, 'w') do |file|
      file.puts 'Mac SKP Icon Repair & Keeper'
      file.puts "Started: #{Time.now}"
      file.puts "Folder: #{expanded}"
      file.puts
    end

    @repair_pid = Process.spawn(
      python, '-u', worker_path, expanded, '--apply',
      out: [report, 'a'], err: [:child, :out]
    )
    Process.detach(@repair_pid)
    UI.messagebox("Folder repair has started in the background.\n\nProgress is written to:\n#{report}\n\nThe report can be safely deleted afterwards.")
  rescue StandardError => error
    UI.messagebox("Folder repair could not start:\n#{error.message}")
  end

  def process_running?(pid)
    Process.kill(0, pid)
    true
  rescue Errno::ESRCH
    false
  rescue Errno::EPERM
    true
  end

  def unsafe_folder?(folder)
    unsafe = ['/', '/System', '/Library', '/Applications', '/private', '/usr', '/bin', '/sbin']
    unsafe.include?(folder)
  end

  def skp_path?(path)
    path && File.extname(path).downcase == '.skp'
  end

  class SavedModelObserver < Sketchup::ModelObserver
    def onPostSaveModel(model)
      SketchUpIconKeeper.queue_refresh(model.path)
    end
  end

  class AppObserver < Sketchup::AppObserver
    def onNewModel(model)
      SketchUpIconKeeper.attach_model(model)
    end

    def onOpenModel(model)
      SketchUpIconKeeper.attach_model(model)
    end
  end

  install
end
