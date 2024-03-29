classdef DofSpace < handle
%  Dof Space
%
%  Static Members:
%    type_int__ = "Input is not int!"
%    type_str__ = "Input is not char!"
%    type_int_vector__ = "Input is not int or vector!"
%    type_str_cell__ = "Input is not char or cell array!"
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

  properties (Constant)
    type_int__ = "Input is not int!"
    type_str__ = "Input is not char!"
    type_int_vector__ = "Input is not int or vector!"
    type_str_cell__ = "Input is not char or cell array!"
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
      % Input: nrow = number of rows (nodes), dof_types = (cell array of) strings of dof names
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
      self.dofspace = [self.dofspace; nan(1, self.ntyp)];
      self.nrow = self.nrow + 1;
      nrow = self.nrow;
    end
    
    function nrow = addRows(self, nrow)
      % Input: nrow = number of rows (nodes) to be added
      self.dofspace = [self.dofspace; nan(nrow, self.ntyp)];
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
      if is_int_vector(irows)
        self.dofspace(irows,:) = [];
        self.nrow = self.nrow - numel(irows);
        self.renumberDofs()
      elseif is_int(irows)
        self.eraseRow(irows)
      else
        error(self.type_int_vector__)
      end
    end

    function nrow = rowCount(self)
      % Output: number of rows (nodes)
      nrow = self.nrow;
    end

    %-------------------------------------------------------------------
    %   Type Methods
    %-------------------------------------------------------------------
    
    function addType(self, dof_type)
      % Input: dof_type = string of dof name
      if ischar(dof_type)
        if ~any(strcmp(self.types, dof_type))
          self.ntyp = self.ntyp + 1;
          self.types{self.ntyp} = dof_type;
          self.dofspace(:,self.ntyp) = nan;
        end
      else
        error(self.type_str__)
      end
    end

    function addTypes(self, dof_types)
      % Input: dof_types = (cell array of) strings of dof names
      if is_cell(dof_types)
        for i = 1:numel(dof_types)
          self.addType(dof_types{i})
        end
      elseif ischar(dof_types)
        self.addType(dof_types)
      else
        error(self.type_str_cell__)
      end
    end

    function setType(self, jtype, dof_type)
      % Input: jtype = dof type index, dof_type = string of dof name
      if ischar(dof_type)
        self.types{jtype} = dof_type;
      else
        error(self.type_str__)
      end
    end

    function dof_type = getTypeName(self, jtype)
      % Input: jtype = dof type index
      % Output: dof_type = string of dof name
      if is_int(jtype)
        dof_type = self.types{jtype};
      else
        error(self.type_int__)
      end
    end
    
    function dof_types = getTypeNames(self, jtypes)
      % Input: jtypes = (vector of) dof type indices
      % Output: dof_types = (cell array of) strings of dof names
      if is_int_vector(jtypes)
        dof_types = {};
        for i = 1:numel(jtypes)
          dof_types{i} = self.types{jtypes(i)};
        end
      elseif is_int(jtypes)
        dof_types = self.types{jtypes};
      else
        error(self.type_int_vector__)
      end
    end

    function jtype = findTypeIndex(self, dof_type)
      % Input: dof_type = string of dof name
      % Output: jtype = dof type index
      if ischar(dof_type)
        jtype = find(strcmp(self.types, dof_type));
      else
        error(self.type_str__)
      end
    end

    function eraseType(self, dof_type)
      % Input: dof_type = string of dof name to be erased
      if ischar(dof_type)
        % Delete column from dofspace
        jtype = strcmp(self.types, dof_type);
        self.dofspace(:, jtype) = [];
        % Delete type
        self.types(jtype) = [];
        self.ntyp = self.ntyp - 1;
        % Renumber dofs
        self.renumberDofs()
      else
        error(self.type_str__)
      end
    end

    function eraseTypes(self, dof_types)
      % Input: dof_types = (cell array of) strings of dof names to be erased
      if is_cell(dof_types)
        for i = 1:numel(dof_types)
          if ischar(dof_types{i})
            % Delete column from dofspace
            jtype = strcmp(self.types, dof_types{i});
            self.dofspace(:, jtype) = [];
            % Delete type
            self.types(jtype) = [];
            self.ntyp = self.ntyp - 1;
          else
            error(self.type_str__)
          end
        end
        % Renumber dofs
        self.renumberDofs()
      elseif ischar(dof_types)
        self.eraseType(dof_types)
      else
        error(self.type_str_cell__)
      end
    end

    function ntyp = typeCount(self)
      % Output: number of dof types
      ntyp = self.ntyp;
    end
    


    %-------------------------------------------------------------------
    %   Dof Methods
    %-------------------------------------------------------------------

    function addDof(self, inod, dof_types)
      % Input: inod = node index, dof_types = (cell array of) strings of dof names 
      if is_cell(dof_types)
        for i = 1:numel(dof_types)
          self.addDof(inod, dof_types{i})
        end
      elseif ischar(dof_types) && is_int(inod)
        jtype = strcmp(self.types, dof_types);
        if isnan(self.dofspace(inod, jtype))
          self.ndof = self.ndof + 1;
          self.dofspace(inod, jtype) = self.ndof;
        end
      else
        error(self.type_dof__)
      end
    end

    function addDofs(self, inodes, dof_types)
      % Input: inodes = (vector of) node indices, dof_types = (cell array of) strings of dof names 
      if is_int_vector(inodes)
        for inod = inodes
          self.addDof(inod, dof_types)
        end
      elseif is_int(inodes)
        self.addDof(inodes, dof_types)
      else
        error(self.type_int_vector__)
      end
    end

    function eraseDof(self, inodes, dof_types)
      % Input: inodes = (vector of) node indices, dof_types = (cell array of) strings of dof names 
      if is_cell(dof_types)
        for i = 1:numel(dof_types)
          jtype = strcmp(self.types, dof_types{i});
          self.dofspace(inodes, jtype) = nan;
        end
      elseif ischar(dof_types)
        jtype = strcmp(self.types, dof_types);
        self.dofspace(inod, jtype) = nan;
      else
        error(self.type_str_cell__)
      end
      self.renumberDofs()
    end

    function eraseDofs(self, inodes, dof_types)
      % Input: inodes = (vector of) node indices, dof_types = (cell array of) strings of dof names 
      self.eraseDofs(inodes, dof_types)
    end
    
    function ndof = dofCount(self)
      % Output: ndof = number of degrees of freedom 
      ndof = self.ndof;
    end

    function idofs = getDofIndex(self, inod, dof_types)
      % Input: inod = node index, dof_types = (cell array of) strings of dof names
      % Output: idof = (vector of) dof indices
      idofs = [];
      if iscell(dof_types)
      elseif is_char(dof_types) && is_int(inod)
      end

    end

    function getDofIndices(self, inodes, dof_types)
      % Input: inodes = (vector of) node indices, dof_types = (cell array of) strings of dof names
      % Output: idofs = (vector of) dof indices 

    end

  end
    
    %-------------------------------------------------------------------
    %   Miscellaneous
    %-------------------------------------------------------------------

  methods(Static)
    function disp(obj, rows)
    % Input: rows = (vector of) row indices to be printed
    % Prints dof space with (given) node number and dof names

      if nargin == 1
        range = 1:obj.nrow;
      elseif nargin == 2
        range = rows; 
      end

      header = ['  ',repmat('%6s ', 1, obj.ntyp),' \n'];
      output = ['%i [',repmat('%6i ', 1, obj.ntyp),'] \n'];
      fprintf(header,obj.types{:})
      for i = range
        fprintf(output, i, obj.dofspace(i,:))
      end
    end
  end
  
  methods (Access = private)   
    function renumberDofs(self)
      disp(self.renumber__)
      self.ndof = 0;
      for i = 1:size(self.dofspace,1)
        for j = 1:size(self.dofspace,2)
          if ~isnan(self.dofspace(i, j))
            self.ndof = self.ndof + 1;
            self.dofspace(i, j) = self.ndof;
          end
        end
      end
    end
  end
end