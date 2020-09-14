class CreateVolunteerInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :volunteer_infos do |t|
      t.string :instagram, limit: 75
      t.string :facebook, limit: 75
      t.string :lattes, limit: 75
      t.string :institution, limit: 75, null: false
      t.string :degree, limit: 75, null: false
      t.string :unemat_bond, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
