addpath utilities

test = 'DofSpace';

if strcmp(test,'DofSpace')
  dofs = DofSpace(1,'u');
  dofs.addRows(10);
  dofs.eraseRows([5, 6, 7, 8, 9, 10]);
  dofs.addRow();
  
  dofs.addType('u');
  dofs.addTypes({'v', 'j', 'rotx', 'roty', 'rotz'});
  dofs.setType(3, 'w');
  dofs.addDofs([1, 3, 5, 6], {'u', 'v', 'w', 'rotx'});
  disp(dofs)
  
  dofs.eraseType('w');
  disp('here')
  disp(dofs)
  dofs.eraseTypes({'rotx', 'roty', 'rotz'});
  disp(dofs)

  dofs.addType('w');
  dofs.addDofs([0,1], 'u');
  dofs.addDof(0, {'u', 'v', 'w'});
  dofs.addDofs(range(6), {'u', 'v', 'w'});
  disp(dofs)

  dofs.eraseDof(0, {'u', 'v', 'w'});
  dofs.eraseDofs([1, 2], 'u');
  dofs.eraseDofs(1, 'v');

  dofs.eraseRow(4);
  disp(dofs)
  disp("Dof count :", dofs.dofCount())

  idofs = dofs.getDofIndices(3);
  idofs = dofs.getDofIndices(3, "u");
  idofs = dofs.getDofIndices(3, {"u", "v"});

  idofs = dofs.getDofIndices([3, 4]);
  idofs = dofs.getDofIndices([3, 4], "u");
  idofs = dofs.getDofIndices([3, 4], {"u","v"});
  disp("idofs =", idofs)

end