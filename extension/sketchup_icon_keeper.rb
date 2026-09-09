require 'sketchup.rb'
require 'extensions.rb'

module SketchUpIconKeeper
  extension = SketchupExtension.new('Mac SKP Icon Repair & Keeper', 'sketchup_icon_keeper/loader')
  extension.description = 'Restores embedded model previews as Finder icons after saves or across an entire folder.'
  extension.version = '0.1.5'
  extension.creator = 'Sam Madwar'
  Sketchup.register_extension(extension, true)
end
