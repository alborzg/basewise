require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context "validations" do
    should "not allow a first name with numbers" do
      user = Fabricate.build(:user, first_name: "foo1")
      assert_not user.valid?
    end

    should "not allow a first name of less than 2 characters" do
      user = Fabricate.build(:user, first_name: "f")
      assert_not user.valid?
    end

    should "not allow a first name of more than 100 characters" do
      user = Fabricate.build(:user, first_name: "f" * 101)
      assert_not user.valid?
    end

    should "not allow a last name of less than 2 characters" do
      user = Fabricate.build(:user, last_name: "")
      assert_not user.valid?
    end

    should "not allow a last name of more than 100 characters" do
      user = Fabricate.build(:user, last_name: "f" * 101)
      assert_not user.valid?
    end

    should "not allow a last name with numbers" do
      user = Fabricate.build(:user, last_name: "foo1")
      assert_not user.valid?
    end

    should "not allow special characters other than !@- in first name" do
      user = Fabricate.build(:user, first_name: "foo&")
      assert_not user.valid?
    end

    should "not allow special characters other than !@- in last name" do
      user = Fabricate.build(:user, last_name: "foo&")
      assert_not user.valid?
    end

    should "not allow a blank email address" do
      user = Fabricate.build(:user, email: "")
      assert_not user.valid?
    end

    should "only allow valid email addresses" do
      user = Fabricate.build(:user, email: "foo@")
      assert_not user.valid?
    end

    should "only allow unique email addresses" do
      Fabricate(:user, email: "foo@bar.com")
      user = Fabricate.build(:user, email: "foo@bar.com")
      assert_not user.valid?
    end

    should "require at least 1 number in the password" do
      user = Fabricate.build(:user, password: "foobar&")
      assert_not user.valid?

    end

    should "require at least one letter" do
      user = Fabricate.build(:user, password: "$$$$$$12")
      assert_not user.valid?

    end

    should "require at least one special character" do
      user = Fabricate.build(:user, password: "foobar1")
      assert_not user.valid?

    end

    should "require the password to be at least 6 characters long" do
      user = Fabricate.build(:user, password: "f1@")
      assert_not user.valid?

    end

    should "not allow a blank password on a new record" do
      user = Fabricate.build(:user, password: "")
      assert_no_difference("User.count") { user.save }
    end

    should "skip validation if the record is not new and the password is blank" do
      user = Fabricate(:user, password: "foobar!23")
      user = User.last
      assert user.valid?
    end

    should "validate the password if the record is not new and the record is not blank" do
      user = Fabricate(:user, password: "foobar#34")
      user.password = "foobar"
      assert_not user.valid?
    end


  end

  context ".authenticate" do
    context "when email is nil" do
      should "return false" do
        assert_not User.authenticate({})
      end
    end

    context "when email is present" do
      context "when the user exists" do
        setup do
          @user = Fabricate(:user)
        end

        should "return the user" do
          assert_equal @user, User.authenticate(email: @user.email, password: @user.password)
        end
      end

      context 'when the user does not exist'do
        should "return false" do
          assert_not User.authenticate(emails: "foobar@foo.com", password: "foobar2$")
        end
       end

    context "when password is ok" do
      setup do
       @user = Fabricate(:user)
      end

      should "return user" do
        assert_equal @user, User.authenticate(email: @user.email, password: @user.password)
      end
    end

    context  "when password is not ok" do
      setup do
        @user = Fabricate(:user)
      end
     end
    end
  end
end