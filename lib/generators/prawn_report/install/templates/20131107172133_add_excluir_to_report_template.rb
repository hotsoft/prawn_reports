class AddExcluirToReportTemplate < ActiveRecord::Migration
  def self.up
    add_column :report_templates, :excluir, :boolean
  end

  def self.down
    remove_column :report_templates, :excluir
  end
end
