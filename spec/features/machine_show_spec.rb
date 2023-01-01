require 'rails_helper'

RSpec.describe "Vending Machine" do
  describe "when I visit the vending machine show page" do
    it 'has the name & price of all the snacks for that vending machine' do
      sam = Owner.create!(name: "Sam's Snacks")
      dons_drinks = sam.machines.create!(location: "Don's Mixed Drinks")

      cheetohs = Snack.create!(name: "Jalapeno Cheetohs", price: 2.50)
      powerade = Snack.create!(name: "Powerade Blue", price: 1.00)
      oreos = Snack.create!(name: "Oreos", price: 0.75)
      chips = Snack.create!(name: "Plain Ol Chips", price: 4.83)

      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: cheetohs.id)
      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: powerade.id)
      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: oreos.id)

      visit "/machines/#{dons_drinks.id}"

      expect(page).to have_content(cheetohs.name)
      expect(page).to have_content(cheetohs.price)
      expect(page).to have_content(powerade.name)
      expect(page).to have_content(powerade.price)
      expect(page).to have_content(oreos.name)
      expect(page).to have_content(oreos.price)
      expect(page).to_not have_content(chips.name)
    end

    it 'shows the average price for all the snacks in this machine' do
      sam = Owner.create!(name: "Sam's Snacks")
      dons_drinks = sam.machines.create!(location: "Don's Mixed Drinks")

      cheetohs = Snack.create!(name: "Jalapeno Cheetohs", price: 3.50)
      powerade = Snack.create!(name: "Powerade Blue", price: 1.50)
      oreos = Snack.create!(name: "Oreos", price: 2.50)

      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: cheetohs.id)
      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: powerade.id)
      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: oreos.id)

      visit "/machines/#{dons_drinks.id}"
save_and_open_page
      expect(page).to have_content("Average Price: $2.50")
    end
  end
end