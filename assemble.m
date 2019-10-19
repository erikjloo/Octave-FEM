nodes = NodeSet;
nodes.addNode([0,0,0])
nodes.addNode([0,10,0])
nodes.addNode([0,20,0])

nodes.getCoords()
elems = ElementSet;
elems.addElement([1,2])
elems.addElement([2,3])


nele = elems.elemCount();
for iele = 1:nele
  % Get element nodes, coordinates, dofs and displacements
  disp(iele)
  
  inodes = elems.getNodes(iele)
  coords = nodes.getCoords(inodes)
  idofs = dofs.getDofIndices()
%  coords = mesh.getCoords(inodes)
%  idofs = mesh.getDofIndices(inodes)
  
  % Initialize element stiffness matrix and internal force vector
  
end

