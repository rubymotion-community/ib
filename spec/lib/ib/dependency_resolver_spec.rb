require 'spec_helper'
require 'ib/dependency_resolver'

describe IB::DependencyResolver do
  context 'init with simple dependency' do
    before do
      @files = {
        'aaa.rb' => [{
            class: [['SubClass1', 'SubClass2']],
          }],
        'bbb.rb' => [{
            class: [['SubClass2', 'SuperClass']],
          }],
        'ccc.rb' => [{
            class: [['SuperClass', 'UIViewController']],
          }],
      }
    end

    describe 'new' do
      it 'create a instance IB::DependencyResolver' do
        resolver = IB::DependencyResolver.new(@files)
        expect(
          resolver.class_nodes.kind_of?(IB::DependencyResolver::TSortHash)
        ).to be_true
      end
    end

    describe 'sort_classes' do
      it 'create a instance IB::DependencyResolver' do
        resolver = IB::DependencyResolver.new(@files)
        expect(
          resolver.sort_classes
        ).to eq(['UIViewController', 'SuperClass', 'SubClass2', 'SubClass1'])
      end
    end

    describe 'sort_files' do
      it 'create a instance IB::DependencyResolver' do
        resolver = IB::DependencyResolver.new(@files)
        expect(
          resolver.sort_files
        ).to eq(['ccc.rb', 'bbb.rb', 'aaa.rb'])
      end
    end
  end

  context 'init with no dependencies' do
    before do
      @files = {
        'aaa.rb' => [{
            class: [['SubClass1']],
          }],
        'bbb.rb' => [{
            class: [['SubClass2']],
          }],
        'ccc.rb' => [{
            class: [['SuperClass']],
          }],
      }
    end

    describe 'sort_classes' do
      it 'create a instance IB::DependencyResolver' do
        resolver = IB::DependencyResolver.new(@files)
        expect(
          resolver.sort_classes
        ).to eq(['SubClass1', 'SubClass2', 'SuperClass'])
      end
    end

    describe 'sort_files' do
      it 'create a instance IB::DependencyResolver' do
        resolver = IB::DependencyResolver.new(@files)
        expect(
          resolver.sort_files
        ).to eq(['aaa.rb', 'bbb.rb', 'ccc.rb'])
      end
    end
  end

  context 'init with dependency in one file' do
    before do
      @files = {
        'aaa.rb' => [{
            class: [['SubClass1', 'SubClass2']],
          },{
            class: [['SubClass2', 'SuperClass']],
          },{
            class: [['SuperClass']],
          }]
      }
    end

    describe 'sort_classes' do
      it 'create a instance IB::DependencyResolver' do
        resolver = IB::DependencyResolver.new(@files)
        expect(
          resolver.sort_classes
        ).to eq(['SuperClass', 'SubClass2', 'SubClass1'])
      end
    end

    describe 'sort_files' do
      it 'create a instance IB::DependencyResolver' do
        resolver = IB::DependencyResolver.new(@files)
        expect(
          resolver.sort_files
        ).to eq(['aaa.rb'])
      end
    end
  end
end
