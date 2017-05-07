class AddPluginPathToStepTypes < ActiveRecord::Migration
  def change
    change_table :step_types do |t|
      t.string :plugin_path
    end
  end
end
