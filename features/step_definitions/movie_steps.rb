# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
      Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

#Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #(page.body =~ /#{e1}.*#{e2}/).should == true
  #index = /#{e1}.*#{e2}/ =~ page.body
  #index.should_not == nil and index.should > 0
  #(/#{e1}.*#{e2}/ =~ page.body).should == nil
  #(/#{e1}.*#{e2}/ =~ page.body).should > 0
#end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
#And /^I should see "([^"]*)" before "([^"]*)"$/ do |phrase_1, phrase_2|
  begin
    e1 = Date.parse(e1).to_s
  rescue ArgumentError => e
  end

  begin
    e2 = Date.parse(e2).to_s
  rescue ArgumentError => e
  end

  index1 = page.body.index(e1)
  index2 = page.body.index(e2)
  index1.should < index2
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split.each do |rating|
    if uncheck
      step "I uncheck \"#{rating}\""
    else
      step "I check \"#{rating}\""
    end
  end

    # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

Then /^(?:|I )should see "(.*)" in rating column$/ do |rating|
  #true.should == (page.all('#movies tbody tr td[2]').include? rating)
  #true.should == page.all('#movies tbody tr td[2]')
  page.all('#movies tbody tr td[2]').map do |el|
    el.text
  end.include?(rating).should == true
end

Then /^(?:|I )should not see "(.*)" in rating column$/ do |rating|
  page.all('#movies tbody tr td[2]').map do |el|
    el.text
  end.include?(rating).should == false
end

Then /^(?:|I )should see all of the movies "(.*)"$/ do |number_of_movies|
  page.all('#movies tbody tr td[2]').count.should == number_of_movies.to_i
end
