classdef ElementSet < handle
%  Element set
%    Instance Members:
%      connectivity = list of element connectivities
%      nele = number of elements
% 
%    Public Methods:
%      ElementSet()
%      iele = addElement(connect)
%      ielements = addElements(connect)
%      setElement(iele, connect)
%      eraseElement(iele)
%      eraseElements(ielements)
%      nele = elemCount()
%      connect[ivity] = getNodes(iele[ments])
%      inodes = getNodeIndices(iele[ments])
%
  properties (Access = private)
      % note: containers.map dont work in Octave
      % idea: use two arrays: one with Element numbers and otter with connectivity
      % use if nargin == 1,...
      % check connect size
    connectivity = []
    nele = 0
    ndim = 3
  end
  methods (Access = public)
    function self = ElementSet()
      self.connectivity = [];
      self.nele = 0;
      self.ndim = 3;
    end
    function addElement(self, connect)
      
      self.connectivity = [self.connectivity; connect];
      self.nele = self.nele + 1;
    end
    function addElements(self, connectivity)
      fprintf('not yet implemented')
    end
    function setElement(self, inod, connect)
      self.connectivity(inod,:) = connect;
    end
    function eraseElement(self, inod)
      self.connectivity(inod,:) = [];
      self.nele = self.nele - 1;    
    end
    function connectivity = getNodes(self, iElement)
      connectivity = self.connectivity(iElement,:);
    end
    function delete()
      fprintf('ItemSet succesfully deleted')
    end
    
    function nele = elemCount(self)
      nele = self.nele;
    end
  end
end