# frozen_string_literal: true

class Combustion::Database::Migrate
  def self.call
    new.call
  end

  def call
    if ActiveRecord::VERSION::STRING >= "3.1.0"
      migrator.migrate paths, nil
    else
      paths.each { |path| migrator.migrate path, nil }
    end
  end

  private

  def base_migration_paths
    if migrator.respond_to?(:migrations_paths)
      migrator.migrations_paths
    else
      Array("db/migrate/")
    end
  end

  def engine_migration_paths
    migration_paths = Rails.application.paths["db/migrate"].to_a

    if engine_paths_exist_in(migration_paths)
      migration_paths
    else
      base_migration_paths + migration_paths
    end
  end

  def engine_path
    Rails.application.root.sub(::Combustion.path, "")
  end

  def engine_paths_exist_in?(paths)
    paths.include?(engine_path.join("db/migrate").to_s)
  end

  def migrator
    @migrator ||= ActiveRecord::Migrator
  end

  def paths
    (engine_migration_paths + [File.join(Rails.root, "db/migrate")]).uniq
  end
end
