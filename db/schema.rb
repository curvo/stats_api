Sequel.migration do
  change do
    create_table(:ar_internal_metadata) do
      column :key, "varchar(255)", :null=>false
      column :value, "varchar(255)"
      column :created_at, "datetime", :null=>false
      column :updated_at, "datetime", :null=>false
      
      primary_key [:key]
    end
    
    create_table(:page_views) do
      primary_key :id, :type=>"int(11)"
      column :url, "varchar(255)"
      column :referrer, "varchar(255)"
      column :created_at, "datetime"
      column :hash, "varchar(255)"
    end
    
    create_table(:schema_migrations) do
      column :version, "varchar(255)", :null=>false
      
      primary_key [:version]
    end
  end
end
