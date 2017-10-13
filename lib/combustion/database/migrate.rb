# frozen_string_literal: true

class Combustion::Database::Migrate
  def self.call
    new.call
  end

  def call
    if ActiveRecord::VERSION::STRING >= '3.1.0'
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
      Array('db/migrate/')
    end
  end

  def migrator
    @migrator ||= ActiveRecord::Migrator
  end

  def paths
    engine_path     = Rails.application.root.sub(::Combustion.path, '')
    migration_paths = Rails.application.paths['db/migrate'].to_a

    if migration_paths.include?(engine_path.join('db/migrate').to_s)
      paths = []
    else
      paths = base_migration_paths
    end

    (paths + migration_paths + [File.join(Rails.root, 'db/migrate')]).uniq
  end
end
