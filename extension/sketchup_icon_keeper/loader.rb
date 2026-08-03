require 'open3'
require 'securerandom'
require 'tmpdir'

module SketchUpIconKeeper
  module_function

  def helper_path
    File.join(__dir__, 'set_finder_icon')
  end

  def install
    # Extension installers do not always retain the executable bit from an
    # RBZ archive, so make the bundled macOS helper runnable on first load.
    File.chmod(0o755, helper_path) if File.file?(helper_path)
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
    system(helper_path, thumbnail, path)
    File.utime(original.atime, original.mtime, path)
  rescue StandardError => error
    puts "SketchUp Icon Keeper: #{error.message}"
  ensure
    File.delete(thumbnail) if thumbnail && File.exist?(thumbnail)
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
