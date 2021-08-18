#!/usr/bin/env rspec -cfd

require_relative '../spec_helper'

# Let autoloads decide the order
require 'pushdown'


RSpec.describe( Pushdown::State ) do

	let( :state_data ) { {} }
	let( :subclass ) do
		Class.new( described_class )
	end

	let( :starting_state_class ) do
		Class.new( described_class )
	end


	it "is an abstract class" do
		expect { described_class.new }.to raise_error( NoMethodError, /\bnew\b/ )
	end


	describe "event handlers" do

		it "has a default (no-op) callback for when it is added to the stack" do
			instance = subclass.new
			expect( instance.on_start(state_data) ).to be_nil
		end


		it "has a default (no-op) callback for when it is removed from the stack" do
			instance = subclass.new
			expect( instance.on_stop(state_data) ).to be_nil
		end


		it "has a default (no-op) callback for when it is pushed down on the stack" do
			instance = subclass.new
			expect( instance.on_pause(state_data) ).to be_nil
		end


		it "has a default (no-op) callback for when the stack is popped and it becomes current again" do
			instance = subclass.new
			expect( instance.on_resume(state_data) ).to be_nil
		end

	end


	describe "update handlers" do

		it "has a default (no-op) interval callback for when it is on the stack" do
			instance = subclass.new
			expect( instance.shadow_update(state_data) ).to be_nil
		end


		it "has a default (no-op) interval callback for when it is current" do
			instance = subclass.new
			expect( instance.update(state_data) ).to be_nil
		end

	end



	describe "transition declaration" do

		it "can declare a push transition" do
			subclass.transition_push( :start, :starting )
			expect( subclass.transitions[:start] ).to eq([ :push, :starting ])
		end


		it "can declare a pop transition" do
			subclass.transition_pop( :undo )
			expect( subclass.transitions[:undo] ).to eq([ :pop ])
		end

	end


end
