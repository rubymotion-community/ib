require 'spec_helper'
require 'ib/oc_interface'

describe IB::OCInterface do
  context 'instantiate' do
    before do
      @params = {
        class: [["CustomView", "UIView"]],
        outlets: [
          ["greenLabel",    "UIGreenLabel"],
          ["redLabel",      "UILabel"],
          ["untyped_label", "id"],
          ["yellowLabel",   "id"]
        ],
        outlet_collections: [
          ["greenLabelCollection",     "UIGreenLabel"],
          ["redLabelCollection",       "UILabel"],
          ["untyped_label_collection", "id"],
          ["yellowLabelCollection",    "id"]
        ],
        actions: [
          ["someAction",              "sender", nil],
          ["segueAction",             "sender", "UIStoryboardSegue"],
          ["anotherAction",           "button", nil],
          ["actionWithComment",       "sender", nil],
          ["actionWithBrackets",      "sender", nil],
          ["actionWithoutArgs",       nil,      nil],
          ["actionWithDefaultedArgs", "sender", nil]
        ]
      }
    end

    let(:subject) { IB::OCInterface.new(@params) }
    describe '#new' do
      it 'should return object' do
        should be_kind_of(IB::OCInterface)
      end
    end

    describe '#[]' do
      it 'should be able to access original params' do
        expect(subject[:class][0][0]).to eq('CustomView')
        expect(subject[:class][0][1]).to eq('UIView')
        expect(subject[:outlets]).to be_kind_of(Array)
      end
    end

    describe '#super_class' do
      it 'should return super class' do
        expect(subject.super_class).to eq('UIView')
      end
    end

    describe '#dependency_classes' do
      it 'should return super class' do
        expect(subject.sub_class_dependencies).to be_kind_of(Array)
        expect(subject.sub_class_dependencies).to eq(%w{
          UIView UIGreenLabel UILabel
        })
      end
    end

    describe '#has_class?' do
      it 'should return super class' do
        expect(subject.has_class?('UIView')).to be_true
        expect(subject.has_class?('FooBarDummyView')).to be_false
      end
    end
  end
end
