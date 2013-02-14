require 'spec_helper'
require 'ruby-debug'

describe MoviesController do
  describe 'searching TMDb' do
    fixtures :movies
    before :each do
      @fake_results = [mock('movie1'), mock('movie2')]
      @fake_movie = mock('Movie')
      @fake_movie.stub(:title).and_return('Casablanca')
      @fake_movie.stub(:rating).and_return('PG')
      @fake_movie.stub(:name_with_rating).and_return('Casablanca (PG)')
    end
    #subject { create :movie, :title => 'Milk', :rating => 'R' }
    it 'makes my test of Factory' do
      movie = FactoryGirl.build(:movie, :title => 'Milk', :rating => 'R')
      movie.title.should == 'Milk'
      movie.rating.should == 'R'
    end
    #its(:name) { should == "Milk" }
    #its(:rating) { should == "R" }
    it 'makes my test of Fixture' do
      movie = movies(:milk_movie)
      movie.title.should == 'Milk'
      movie.rating.should == 'R'
    end
    it 'makes my test of Mocks' do
      @fake_movie.name_with_rating.should == 'Casablanca (PG)'
    end
    it 'should call the model method that performs TMDb search' do
      Movie.should_receive(:find_in_tmdb).with('hardware').
          and_return(@fake_results)
      post :search_tmdb, {:search_terms => 'hardware'}
    end
    describe 'After valid search' do
      before :each do
          Movie.stub(:find_in_tmdb).and_return(@fake_results)
          post :search_tmdb, {:search_terms => 'hardware'}
      end
      it 'should select the Search Results template for rendering' do
        response.should render_template('search_tmdb')
      end
      it 'should make the TMDb search results available to that template' do
        assigns(:movies).should == @fake_results
      end
    end
  end
end