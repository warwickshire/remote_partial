# This migration comes from remote_partial (originally 20130702072157)
class CreateRemotePartialPartials < ActiveRecord::Migration
  def change
    create_table :remote_partial_partials do |t|
      t.string :name,    limit: 100,   null: false
      t.text   :url,     limit: 0x7ff, null: false
      t.string :criteria
      t.float  :repeat_period
      t.timestamps
    end
  end
end
