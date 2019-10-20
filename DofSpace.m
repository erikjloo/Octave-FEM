classdef DofSpace < handle
%  Dof Space
%
%  Static Members:
%    type_int__ = "Input is not int!"
%    type_char__ = "Input is not char!"
%    type_int_vector__ = "Input is not int or vector!"
%    type_char_cell__ = "Input is not char or cell!"
%    type_dof__ = "Input inod is not int or dof is not char!"
%    renumber__ = "Erasing dofs: Dof numbers will be renumbered!"
%
%  Instance Members:
%    nrow = number of rows (nodes)
%    types = vector of dof names
%    dofspace = array of dof indices (idofs)
%           i row corresponds to inod
%           j column corresponds to jtype
%           idof = dofspace[inod,jtype]
%    ndof = number of degrees of freedom
% 
%  Public Methods:
%    DofSpace(nrow, ntyp)
% 
%    Row Methods:
%      nrow = addRow()
%      nrow = addRows(nrow)
%      eraseRow(irow)
%      eraseRows(irows)
%      nrow = rowCount()
%           
%    Type Methods:
%      addType(dof)
%      addTypes(dofs)
%      setType(jtype, dof)
%      eraseType(dof)
%      eraseTypes(dofs)
%      ntyp = typeCount()
%      dof = getTypeName(jtype)
% 
%    Dof Methods:
%      addDof(inod, dofs)
%      addDofs(inodes, dofs)
%      eraseDof(inod, dofs)
%      eraseDofs(inodes, dofs)
%      ndof = dofCount()
%      idof[s] = getDofIndex(inod, dof)
%      idofs = getDofIndices(inodes, dofs)
%       
%    Miscellaneous:
%      printDofSpace(irows)
% 
%    Private Methods:
%      renumberDofs()

  properties (Constant = true)
    type_int__ = "Input is not int!"
    type_char__ = "Input is not char!"
    type_int_vector__ = "Input is not int or vector!"
    type_char_cell__ = "Input is not char or cell!"
    type_dof__ = "Input inod is not int or dof is not char!"
    renumber__ = "Erasing dofs: Dof numbers will be renumbered!"
  end

  properties (Access = private)
    nrow = 0
    ntyp = 0
    ndof = 0
    types = {}
    dofspace = []
  end

  methods (Access = public)
    
    %-------------------------------------------------------------------
    %   Constructor
    %-------------------------------------------------------------------
    
    function self = DofSpace(nrow, dof_types)
      % Input: nrow = number of rows (nodes), ntyp = number of dof types
      if nargin == 1
        self.nrow = nrow;
      elseif nargin == 2
        self.nrow = nrow;
        self.addTypes(dof_types);
      elseif nargin > 2
        error("Varargin are nrow = number of rows & ntyp = number of dof types")
      end
      self.dofspace = nan(self.nrow, self.ntyp);
    end
  
    %-------------------------------------------------------------------
    %   Row Methods
    %-------------------------------------------------------------------
    
    function nrow = addRow(self)
      % Adds a new row to dofspace
      self.dofspace(self.nrow + 1,:) = nan;
      self.nrow = self.nrow + 1;
      nrow = self.nrow;
    end
    
    function nrow = addRows(self, nrow)
      % Input: nrow = number of rows (nodes) to be added
      r_new = nan(nrow, self.ntyp);
      self.dofspace = [self.dofspace; r_new];
      self.nrow = self.nrow + nrow;
      nrow = self.nrow;
    end
    
    function eraseRow(self, irow)
      % Input: irow = index of row (node) to be erased
      if is_int(irow)
        self.dofspace(irow,:) = [];
        self.nrow = self.nrow - 1;
        self.renumberDofs()
      else
        error(self.type_int__)
      end
    end
    
    function eraseRows(self, irows)
      % Input: irows = (vector of) indices of rows (nodes) to be erased
      if isvector(irows)
        self.dofspace(irows,:) = [];
        self.nrow = self.nrow - length(irows);
        self.renumberDofs()
        % irows = sort(irows,'descend');
        % for i = 1:length(irows)
        %   self.eraseRow(irows(i))
        % end
      elseif is_int(irow)
        self.eraseRow(irows)
      else
        error(self.type_int_vector__)
      end
    end

    function nrow = rowCount(self)
      nrow = self.nrow;
    end

    %-------------------------------------------------------------------
    %   Type Methods
    %-------------------------------------------------------------------
    
    function addType(self, dof_type)
      % Input: dof_type = char of dof name
      if ischar(dof_type) 
        if ~any(strcmp(self.types, dof_type))
          self.ntyp = self.ntyp + 1;
          self.types{self.ntyp} = dof_type;
          self.dofspace(:,self.ntyp) = nan;
        end
      else
        error(type_char__)
      end
    end

    function addTypes(self, dof_types)
      % Input: dof_types = (cell of) chars of dof names
      if is_cell(dof_types)
        for i = 1:length(dof_types)
          self.addType(dof_types{i})          
        end
      elseif ischar(dof_types)
        self.addType(dof_types)
      else
        error(type_char_cell__)
      end
    end

    function setType(self, jtype, dof_type)
      % Input: jtype = dof type index, dof = char of dof name
      if ischar(dof_type)
        self.types{jtype} = dof_type;
      end
    end

    function eraseType(self, dof_type)
      % Input: dof = string of dof name to be erased
      if ischar(dof_type)
        % Delete column from dofspace
        jtype = find(strcmp(self.types, dof_type));
        self.dofspace(:, jtype) = [];
        % Delete type
        self.types(jtype) = [];
        self.ntyp = self.ntyp - 1;
        % Renumber dofs
        self.renumberDofs()
      end
    end

    function eraseTypes(self, dof_types)
      % Input: dofs = (cell of) chars of dof names to be erased
      if is_cell(dof_types)
        for i = 1:length(dof_types)
          % Delete column from dofspace
          jtype = find(strcmp(self.types, dof_types{i}));
          self.dofspace(:, jtype) = [];
          % Delete type
          self.types(jtype) = [];
          self.ntyp = self.ntyp - 1;
        end
        % Renumber dofs
        self.renumberDofs()
      elseif ischar(dof_types)
        self.eraseType(dof_types)
      else
        error(type_char_cell__)
      end
    end

    function ntyp = typeCount(self)
      ntyp = self.ntyp;
    end

    %-------------------------------------------------------------------
    %   Dof Methods
    %-------------------------------------------------------------------

    function addDof(self, inod, dof_types)
      if is_cell(dof_types)
        for i = 1:length(dof_types)
          self.addDof(inod, dof_types{i})
        end
      elseif ischar(dof_types) && is_int(inod)
        jtype = find(strcmp(self.types, dof_types));
        if isnan(self.dofspace(inod, jtype))
          self.ndof = self.ndof + 1;
          self.dofspace(inod, jtype) = self.ndof;
        end
      end
    end

    function addDofs(self, inodes, dof_types)
      if isvector(inodes)
      end
    end

    function eraseDof(self, inod, dof_types)
    end

    function eraseDofs(self, inodes, dof_types)
    end
    
    function dofCount(self)
    end

    function getDofIndex(self, inod, dof_types)
    end

    function getDofIndices(self, inodes, dof_types)
    end

    function disp(obj, rows)
      % disp(obj.types)
      if nargin == 1
        for i = 1:obj.nrow
          output = ['%i [',repmat('%i ', 1, obj.ntyp),'] \n'];
          fprintf(output, i, obj.dofspace(i,:))
        end
      elseif nargin == 2
      end

    end
  end
  
  methods (Access = private)
    
    function renumberDofs(self)
      disp(self.renumber__)
      self.ndof = 1;
      for i = 1:size(self.dofspace,1)
        for j = 1:size(self.dofspace,2)
          if ~isnan(self.dofspace(i, j))
            self.dofspace(i, j) = self.ndof;
            self.ndof = self.ndof + 1;
          end
        end
      end
    end
  end
end