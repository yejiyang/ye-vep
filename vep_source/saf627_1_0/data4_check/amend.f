c       to make 3D mesh, repeat the 2d mesh in the 3rd dimension
        parameter (n=500000,nf=90000)
        implicit real*8 (a-h,o-z)
      dimension x(n),y(n)
      dimension nod(5,n),npoint(2,1000)
      character*100 meshname  

c     **********************************************************
c       knode means the total number of nodes
c       nqudr means the total number of elements
c       there two parameter should manually input, which can be 
c       found at the 'add2.flavia.msh' file
      open(1,file='input_datapre',status='old')
      read(1,*)knode, nqudr
      read(1,*)meshname
      write(*,*)knode, nqudr,meshname
      close(1)
c     ***********************************************************
c     *********read inputfile 'add2.flavia.msh '*****************
c      open(1,file='saf1_mat.flavia.msh',status='old')
      open(1,file=meshname,status='old')
      x0=0.d0
      y0=0.d0
      read(1,*)
      read(1,*)
      do i=1,knode
      read(1,*) ii,x(i),y(i)
      write(*,*) ii,x(i),y(i)
      x(i)=x(i)-x0
      y(i)=y(i)-y0
      enddo
      read(1,*)
      read(1,*)
c       for GID10, need read 3 lines
      read(1,*)      
      do i=1,nqudr
      read(1,*) ii,nod(1,i),nod(2,i),nod(3,i),nod(4,i),nod(5,i)
      enddo
      write(*,*) 'nqudr =',nqudr
      close(1)


      open(30,file='amend.flavia.msh',status='unknown',
     +        form='formatted')
c      write(30,*)
      write(30,*)'Mesh "q4" Dimension 2 Elemtype Quadrilateral Nnode 4'
c      write(30,*)'Mesh "q4" Dimension 2 Elemtype Triangle Nnode 3'
      write(30,*)'Coordinates'
      do i = 1,knode
      write(30,1001) i,x(i),y(i)
      end do
      write(30,*)'End coordinates'
      write(30,*) 'Elements'
      do i=1,nqudr
      write(30,1101)i,(nod(j,i),j=1,5)
      end do
      write(30,*)'End elements'
      close(30)

      open(30,file='data1',status='unknown',
     +        form='formatted')
      write(30,*)knode
      do i = 1,knode
      write(30,1001) i,x(i),y(i)
      end do
      write(30,*) nqudr
      do i=1,nqudr
      write(30,1101)i,(nod(j,i),j=1,5)
      end do
      close(30)

1001  format(i10,3es15.6)
1101  format(15i10)

      end 
