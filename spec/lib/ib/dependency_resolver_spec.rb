require 'spec_helper'
require 'ib/dependency_resolver'

describe IB::DependencyResolver do
  context 'init with simple dependency' do
    before do
      @files = {
        'aaa.rb' => [IB::OCInterface.new({
            class: [['SubClass1', 'SubClass2']],
          })],
        'bbb.rb' => [IB::OCInterface.new({
            class: [['SubClass2', 'SuperClass']],
          })],
        'ccc.rb' => [IB::OCInterface.new({
            class: [['SuperClass', 'UIViewController']],
          })],
      }
    end

    describe 'new' do
      it 'create a instance IB::DependencyResolver' do
        resolver = IB::DependencyResolver.new(@files)
        expect(
          resolver.dependency_graph.kind_of?(IB::DependencyResolver::TSortHash)
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
        'aaa.rb' => [
          IB::OCInterface.new({
              class: [['SubClass1']],
            }
          )
        ],
        'bbb.rb' => [IB::OCInterface.new({
            class: [['SubClass2']],
            })
        ],
        'ccc.rb' => [IB::OCInterface.new({
            class: [['SuperClass']],
            })
        ],
      }
    end

    describe 'sort_classes' do
      it 'create a instance IB::DependencyResolver' do
        resolver = IB::DependencyResolver.new(@files)
        expect(
          resolver.sort_classes
        ).to eq(['SubClass1', 'NSObject','SubClass2', 'SuperClass'])
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
        'aaa.rb' => [
          IB::OCInterface.new({
              class: [['SubClass1', 'SubClass2']],
            }
          ),
          IB::OCInterface.new({
              class: [['SubClass2', 'SuperClass']],
            }
          ),
          IB::OCInterface.new({
              class: [['SuperClass']],
            }
          ),
        ],
      }
    end

    describe 'sort_classes' do
      it 'create a instance IB::DependencyResolver' do
        resolver = IB::DependencyResolver.new(@files)
        expect(
          resolver.sort_classes
        ).to eq(['SuperClass', 'SubClass2', 'SubClass1', 'NSObject'])
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

  context 'init with complex dependencies' do
    before do
      @files = {
        'aaa.rb' => [
          IB::OCInterface.new({
              class: [['SubClass1', 'SubClass2']],
              outlets: [
                ["greenLabel",    "UIGreenLabel"],
              ],
            }
          )
        ],
        'bbb.rb' => [
          IB::OCInterface.new({
              class: [['SubClass2', 'SuperClass']],
            }
          )
        ],
        'ccc.rb' => [
          IB::OCInterface.new({
              class: [['SuperClass', 'UIViewController']],
            }
          )
        ],
        'ddd.rb' => [
          IB::OCInterface.new({
              class: [['UIGreenLabel', 'UIView']],
            }
          )
        ],
      }
    end

    describe 'new' do
      it 'create a instance IB::DependencyResolver' do
        resolver = IB::DependencyResolver.new(@files)
        expect(
          resolver.dependency_graph.kind_of?(IB::DependencyResolver::TSortHash)
        ).to be_true
      end
    end

    describe 'sort_classes' do
      it 'create a instance IB::DependencyResolver' do
        resolver = IB::DependencyResolver.new(@files)
        expect(
          resolver.sort_classes
        ).to eq(['UIViewController', 'SuperClass', 'SubClass2', 'UIView', 'UIGreenLabel', 'SubClass1'])
      end
    end

    describe 'sort_files' do
      it 'create a instance IB::DependencyResolver' do
        resolver = IB::DependencyResolver.new(@files)
        expect(
          resolver.sort_files
        ).to eq(['ccc.rb', 'bbb.rb', 'ddd.rb', 'aaa.rb'])
      end
    end
  end

end
