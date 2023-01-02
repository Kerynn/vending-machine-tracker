require 'rails_helper'

RSpec.describe "snacks" do
  describe "when I visit the snack show page" do
    it 'shows the name of the snack and its price' do
      cheetohs = Snack.create!(name: "Jalapeno Cheetohs", price: 2.50)

      visit "/snacks/#{cheetohs.id}"

      expect(page).to have_content(cheetohs.name)
      expect(page).to have_content("Price: $2.50")
    end

    it 'shows a list of locations with vending machines with that snack' do
      cheetohs = Snack.create!(name: "Jalapeno Cheetohs", price: 2.50)

      sam = Owner.create!(name: "Sam's Snacks")
      dons_drinks = sam.machines.create!(location: "Don's Mixed Drinks")
      turing = sam.machines.create!(location: "Turing Basement")
      mountain_view = sam.machines.create!(location: "Mountain View High School")
      sacred_heart = sam.machines.create!(location: "Sacred Heart Hospital")

      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: cheetohs.id)
      MachineSnack.create!(machine_id: turing.id, snack_id: cheetohs.id)
      MachineSnack.create!(machine_id: mountain_view.id, snack_id: cheetohs.id)

      visit "/snacks/#{cheetohs.id}"

      expect(page).to have_content(dons_drinks.location)
      expect(page).to have_content(turing.location)
      expect(page).to have_content(mountain_view.location)
      expect(page).to_not have_content(sacred_heart.location)
    end

    it 'shows the average price for snacks and snack count for each machine' do
      cheetohs = Snack.create!(name: "Jalapeno Cheetohs", price: 2.50)

      sam = Owner.create!(name: "Sam's Snacks")
      
      dons_drinks = sam.machines.create!(location: "Don's Mixed Drinks")
      powerade = Snack.create!(name: "Powerade Blue", price: 1.00)
      oreos = Snack.create!(name: "Oreos", price: 0.75)
      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: powerade.id)
      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: oreos.id)
      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: cheetohs.id)

      turing = sam.machines.create!(location: "Turing Basement")
      chips = Snack.create!(name: "Plain Ol Chips", price: 4.00)
      MachineSnack.create!(machine_id: turing.id, snack_id: chips.id)
      MachineSnack.create!(machine_id: turing.id, snack_id: cheetohs.id)

      mountain_view = sam.machines.create!(location: "Mountain View High School")
      MachineSnack.create!(machine_id: mountain_view.id, snack_id: cheetohs.id)

      visit "/snacks/#{cheetohs.id}"
   
      expect(page).to have_content("#{dons_drinks.location} (3 kinds of snacks, average price of $1.42)")
      expect(page).to have_content("#{turing.location} (2 kinds of snacks, average price of $3.25)")
      expect(page).to have_content("#{mountain_view.location} (1 kinds of snacks, average price of $2.50)")
    end
  end
end