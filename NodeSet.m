classdef NodeSet < handle
%  Node Set 
%    Instance Members:
%      coords = list of nodal coordinates
%      nnod = number of nodes
% 
%    Public Methods:
%      NodeSet()
%      inod = addNode(coord)
%      inodes = addNodes(coords)
%      setNode(inod, coord)
%      eraseNode(inod)
%      eraseNodes(inodes)
%      nnod = nodeCount()
%      coord[s] = getCoords(inod[es])
%
  properties (Access = private)
      % note: containers.map dont work in Octave
      % idea: use two arrays: one with node numbers and otter with coords
      % use if nargin == 1,...
      % check coord size
    coords = []
    nnod = 0
    ndim = 3
  end
  methods (Access = public)
    function self = NodeSet()
      self.coords = [];
      self.nnod = 0;
      self.ndim = 3;
    end
    function addNode(self, coord)
      
      self.coords = [self.coords; coord];
      self.nnod = self.nnod + 1;
    end
    function addNodes(self, coords)
      fprintf('not yet implemented')
    end
    function setNode(self, inod, coord)
      self.coords(inod,:) = coord;
    end
    function eraseNode(self, inod)
      self.coords(inod,:) = [];
      self.nnod = self.nnod - 1;    
    end
    function coords = getCoords(self, inod)
      if nargin == 1
        coords = self.coords;
      elseif nargin == 2
        coords = self.coords(inod,:);
      end
    end
    function delete()
      fprintf('ItemSet succesfully deleted')
    end
    
    function nnod = nodeCount(self)
      nnod = self.nnod;
    end
  end
end