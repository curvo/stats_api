Sequel.migration do
  up do
    create_table(:page_views) do
      primary_key :id
      String :url
      String :referrer, null: true
      DateTime :created_at
      String :hash
    end
  end

  down do
    drop_table(:page_views)
  end
end
