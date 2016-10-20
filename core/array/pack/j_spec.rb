require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)
require File.expand_path('../shared/basic', __FILE__)
require File.expand_path('../shared/numeric_basic', __FILE__)
require File.expand_path('../shared/integer', __FILE__)

ruby_version_is '2.3' do

  platform_is wordsize: 64 do

    describe "Array#pack with format 'J'" do
      it_behaves_like :array_pack_basic, 'J'
      it_behaves_like :array_pack_basic_non_float, 'J'
      it_behaves_like :array_pack_arguments, 'J'
      it_behaves_like :array_pack_numeric_basic, 'J'
      it_behaves_like :array_pack_integer, 'J'
    end

    describe "Array#pack with format 'j'" do
      it_behaves_like :array_pack_basic, 'j'
      it_behaves_like :array_pack_basic_non_float, 'j'
      it_behaves_like :array_pack_arguments, 'j'
      it_behaves_like :array_pack_numeric_basic, 'j'
      it_behaves_like :array_pack_integer, 'j'
    end

    describe "Array#pack with modifier '_'" do
      it_behaves_like :array_pack_64bit_le, 'J_'
      it_behaves_like :array_pack_64bit_le, 'j_'
    end

    describe "Array#pack with modifier '!'" do
      it_behaves_like :array_pack_64bit_le, 'J!'
      it_behaves_like :array_pack_64bit_le, 'j!'
    end

    describe "Array#pack with modifier '<' and '_'" do
      it_behaves_like :array_pack_64bit_le, 'J<_'
      it_behaves_like :array_pack_64bit_le, 'J_<'
      it_behaves_like :array_pack_64bit_le, 'j<_'
      it_behaves_like :array_pack_64bit_le, 'j_<'
    end

    describe "Array#pack with modifier '<' and '!'" do
      it_behaves_like :array_pack_64bit_le, 'J<!'
      it_behaves_like :array_pack_64bit_le, 'J!<'
      it_behaves_like :array_pack_64bit_le, 'j<!'
      it_behaves_like :array_pack_64bit_le, 'j!<'
    end

    describe "Array#pack with modifier '>' and '_'" do
      it_behaves_like :array_pack_64bit_be, 'J>_'
      it_behaves_like :array_pack_64bit_be, 'J_>'
      it_behaves_like :array_pack_64bit_be, 'j>_'
      it_behaves_like :array_pack_64bit_be, 'j_>'
    end

    describe "Array#pack with modifier '>' and '!'" do
      it_behaves_like :array_pack_64bit_be, 'J>!'
      it_behaves_like :array_pack_64bit_be, 'J!>'
      it_behaves_like :array_pack_64bit_be, 'j>!'
      it_behaves_like :array_pack_64bit_be, 'j!>'
    end

  platform_is wordsize: 32 do

      describe "Array#pack with format 'J'" do
        it_behaves_like :array_pack_basic, 'J'
        it_behaves_like :array_pack_basic_non_float, 'J'
        it_behaves_like :array_pack_arguments, 'J'
        it_behaves_like :array_pack_numeric_basic, 'J'
        it_behaves_like :array_pack_integer, 'J'
      end

      describe "Array#pack with format 'j'" do
        it_behaves_like :array_pack_basic, 'j'
        it_behaves_like :array_pack_basic_non_float, 'j'
        it_behaves_like :array_pack_arguments, 'j'
        it_behaves_like :array_pack_numeric_basic, 'j'
        it_behaves_like :array_pack_integer, 'j'
      end

      describe "Array#pack with modifier '_'" do
        it_behaves_like :array_pack_32bit_le, 'J_'
        it_behaves_like :array_pack_32bit_le, 'j_'
      end

      describe "Array#pack with modifier '!'" do
        it_behaves_like :array_pack_32bit_le, 'J!'
        it_behaves_like :array_pack_32bit_le, 'j!'
      end

      describe "Array#pack with modifier '<' and '_'" do
        it_behaves_like :array_pack_32bit_le, 'J<_'
        it_behaves_like :array_pack_32bit_le, 'J_<'
        it_behaves_like :array_pack_32bit_le, 'j<_'
        it_behaves_like :array_pack_32bit_le, 'j_<'
      end

      describe "Array#pack with modifier '<' and '!'" do
        it_behaves_like :array_pack_32bit_le, 'J<!'
        it_behaves_like :array_pack_32bit_le, 'J!<'
        it_behaves_like :array_pack_32bit_le, 'j<!'
        it_behaves_like :array_pack_32bit_le, 'j!<'
      end

      describe "Array#pack with modifier '>' and '_'" do
        it_behaves_like :array_pack_32bit_be, 'J>_'
        it_behaves_like :array_pack_32bit_be, 'J_>'
        it_behaves_like :array_pack_32bit_be, 'j>_'
        it_behaves_like :array_pack_32bit_be, 'j_>'
      end

      describe "Array#pack with modifier '>' and '!'" do
        it_behaves_like :array_pack_32bit_be, 'J>!'
        it_behaves_like :array_pack_32bit_be, 'J!>'
        it_behaves_like :array_pack_32bit_be, 'j>!'
        it_behaves_like :array_pack_32bit_be, 'j!>'
      end
    end
  end
end
