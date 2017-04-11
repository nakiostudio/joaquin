class AddBasicProperties < ActiveRecord::Migration

  def change
    change_table :nodes do |t|
      t.string :token,            null: false, default: ''
      t.integer :status,          null: false, default: 0
      t.string :alias,            null: true

      # System information
      t.string :os,               null: true
      t.string :arch,             null: true
      t.string :system,           null: true
      t.string :local_host,       null: true
      t.string :ip_address,       null: true
      t.string :shell,            null: true
      t.string :user,             null: true
      t.string :home_dir,         null: true
      t.string :port,             null: true
      t.string :public_host,      null: true

      # Timestamps
      t.timestamp :last_active,   null: true
    end

    change_table :job_types do |t|
      t.string :slug,             null: false, default: ''
      t.string :name,             null: false, default: ''
    end

    change_table :step_types do |t|
      t.string :slug,             null: false, default: ''
      t.string :name,             null: false, default: ''
      t.string :script,           null: false, default: ''
      t.string :plugin_data,      null: true
      t.belongs_to :job_type, index: true
    end

    # Indexes
    add_index :nodes, :token,     unique: true
    add_index :step_types, :slug, unique: true
    add_index :job_types, :slug,  unique: true
  end

end
