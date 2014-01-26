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
end