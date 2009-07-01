require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  def test_should_not_save_category_without_title
    category = Category.new
    assert !category.save, 'Category saved without title'
  end

  def test_should_not_save_category_with_empty_title
    category = Category.new(:title => '')
    assert !category.save, 'Category saved with empty title'
  end

  def test_should_not_save_category_with_short_title
    category = Category.new(:title => 'ok')
    assert !category.save, 'Category saved with short title'
  end

  def test_should_not_save_category_with_long_title
    category = Category.new(:title => 'long title' * 50)
    assert !category.save, 'Category saved with long title'
  end

  def test_should_save_category
    category = Category.new(:title => 'My category')
    assert category.save, 'Category not saved'
  end

  def test_should_category_have_position
    first  = Category.create!(:title => 'First category')
    second = Category.create!(:title => 'Second category')

    assert_operator first.position, :<, second.position
  end

  def test_should_category_show_as_its_title
    category = Category.create!(:title => 'Some category')
    assert_equal "#{category}", 'Some category'
  end
end 

