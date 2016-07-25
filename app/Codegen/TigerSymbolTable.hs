{-# LANGUAGE TemplateHaskell #-}

module Codegen.TigerSymbolTable where

import Tiger.TigerLanguage


import qualified LLVM.General.AST as AST
import qualified LLVM.General.AST.Type as Type

import Control.Lens
import qualified Data.Map as Map
import Data.Map.Lens

-- Type table: Assuming there is only one scope of types
-- report error if one type shadows the other
type TypeTable = Map.Map Symbol Type.Type

-- symbol table
type SymbolTable = [Map.Map Symbol AST.Operand]

lookupST :: SymbolTable -> Symbol -> AST.Operand
lookupST st s = case st of
  []        -> error $ "Local variable not in scope: " ++ show s
  otherwise -> case (head st)^.at s of
              Just x  -> x
              Nothing -> lookupST (tail st) s

-- Name Table
type Names = Map.Map Symbol Int
emptyNames :: Names
emptyNames = Map.empty

-- TODO: add more base types.
baseVarType = [("int", Type.i64)]
baseFunType = []

emptySymbolTable :: SymbolTable
emptySymbolTable = [Map.empty]

initTypeTable :: TypeTable
initTypeTable = Map.fromList [("int", Type.i64)]

