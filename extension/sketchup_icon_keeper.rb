require 'sketchup.rb'
require 'extensions.rb'

module SketchUpIconKeeper
  extension = SketchupExtension.new('SketchUp Icon Keeper', 'sketchup_icon_keeper/loader')
  extension.description = 'Restores the Finder icon from a saved SketchUp model’s embedded thumbnail.'
  extension.version = '0.1.2'
  extension.creator = 'SketchUp Icon Keeper'
  Sketchup.register_extension(extension, true)
end
