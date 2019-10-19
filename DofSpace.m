classdef DofSpace < handle
%  Dof Space
%    Instance Members:
%      nrow = number of rows (nodes)
%      types = list of dof names
%      dofspace = array of dof indices (idofs)
%             i row corresponds to inod
%             j column corresponds to jtype
%             idof = dofspace[inod,jtype]
%      ndof = number of degrees of freedom
% 
%    Public Methods:
%      DofSpace(nrow, ntyp)
% 
%      Row Methods:
%        nrow = addRow()
%        nrow = addRows(nrow)
%        eraseRow(irow)
%        eraseRows(irows)
%        nrow = rowCount()
%             
%      Type Methods:
%        addType(dof)
%        addTypes(dofs)
%        setType(jtype, dof)
%        eraseType(dof)
%        eraseTypes(dofs)
%        ntyp = typeCount()
%        dof = getTypeName(jtype)
% 
%      Dof Methods:
%        addDof(inod, dofs)
%        addDofs(inodes, dofs)
%        eraseDof(inod, dofs)
%        eraseDofs(inodes, dofs)
%        ndof = dofCount()
%        idof[s] = getDofIndex(inod, dof)
%        idofs = getDofIndices(inodes, dofs)
%         
%      Miscellaneous:
%        printDofSpace(irows)
% 
%    Private Methods:
%      renumberDofs()
  properties (Access = private)
  end


  methods (Access = public)
    
    %-------------------------------------------------------------------
    %   Constructor
    %-------------------------------------------------------------------
    function self = DofSpace(self, nrow, ntyp)
      self.nrow = nrow;
      self.types = [];
      self.dofspace = NaN(nrow, ntyp);
      self.ndof = 0
    end
  
    %-------------------------------------------------------------------
    #   Row Methods
    #-------------------------------------------------------------------
    function nrow = addRow(self)
      self.dofspace(size(self.dofspace,1)+1,:) = NaN;
      self.nrow = size(self.dofspace,1);
      nrow = self.nrow;
    end
    
    function nrow = addRows(self, nrow)
      self.dofspace(size(self.dofspace,1)+ndof,:) = NaN;
      self.nrow = size(self.dofspace,1);
      nrow = self.nrow;
    end
    
    function eraseRow(self, irows)

      end
    
    #-------------------------------------------------------------------
    #   Type Methods
    #-------------------------------------------------------------------
  methods (Access = private)
      function renumberDofs()

      end
  end
end