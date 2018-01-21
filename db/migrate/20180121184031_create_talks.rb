class CreateTalks < ActiveRecord::Migration[5.1]
  def up
    create_table :talks do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.string :event_name, null: false
      t.date :presented_on, null: false
      t.text :description

      t.timestamps
    end
    add_index :talks, :presented_on, order: { presented_on: :desc }

    [
      {
        title: 'Reporting on Rails - ActiveRecord and ROLAP Working Together',
        event_name: 'RailsConf 2017',
        url: 'https://www.youtube.com/watch?v=MczzCfTQGfU',
        presented_on: '2017-04-27',
        description: '<iframe width="560" height="315" src="https://www.youtube.com/embed/MczzCfTQGfU?rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>'
      },
      {
        title: 'Testing Gems Against Different Databases and Rails Versions',
        event_name: 'Indy.RB',
        url: 'https://www.youtube.com/watch?v=7H6AiL7Hi7I',
        presented_on: '2017-06-14',
        description: '<iframe width="560" height="315" src="https://www.youtube.com/embed/7H6AiL7Hi7I?rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>'
      },
      {
        title: 'Arbitrary Multi-Tenant Configuration for <strike>Fun and</strike> Profit',
        event_name:	'Indy.RB',
        presented_on: '2016-09-14',
        url: 'https://www.youtube.com/watch?v=U_u2w7qNRWg',
        description: '<iframe width="560" height="315" src="https://www.youtube.com/embed/U_u2w7qNRWg?rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>'
      }
    ].each do |t|
      Talk.create!(t)
    end
  end

  def down
    drop_table :talks
  end
end
