require "spec_helper"

describe RestaurantHelper, "#get_menu_data" do

  it "ignores mensa hamm" do
	file_name = "./spec/fixtures/example_stwb_input.csv"
    restaurant = double("restaurant")
    restaurant.stub(:menus).and_return(double("menus", :where => [false]))
    Restaurant.stub(:where).and_return([restaurant]) 
    parsed_data = RestaurantHelper.get_menu_data(file_name)
    parsed_data.length.should equal 3
  end

  it "correctly parses simple example" do
  	file_name = "./spec/fixtures/stwb_simple_input.csv"
    restaurant = double("restaurant")
    restaurant.stub(:menus).and_return(double("menus", :where => [false]))
    Restaurant.stub(:where).and_return([restaurant]) 
    parsed_data = RestaurantHelper.get_menu_data(file_name)
    parsed_data.keys.length.should equal 1
    parsed_data.each do |restaurant, menus|
    	menus.length.should eq 1
    	menus.first["name_translations"]["de"].should eq "Mittagessen"
    	menus.first["description_translations"]["de"].should eq "Mousse au chocolat"
      badges = menus.first["badges"].map { |t| t["de"] }
      badges.include?("fettfrei").should eq true
      badges.include?("kalorienarm").should eq true
    	menus.first["badges"].length.should eq 2
    end
  end
end