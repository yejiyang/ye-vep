c      this program deal with the results data
c      creat the selected data files, the data is on surface, 
c      upper crust and lower crust ...

      program selnodesort 
      implicit real*8 (a-h,l,o-z)
       
      dimension nscoor(4,1000000)
      integer sn 
      
c       add by jiyang
c       output the selected node's velocities
c       the sel_nodes in the 'saf1_sel.node0'
      open(10,file='saf1sel.node', status='old')
      read(10,*) 
      read(10,*) nns, mns
c      write(*,*) nns, mns
c       nns means rows mns means columns 
      do i=1,nns
      read(10,*) (nscoor(j,i),j=1,4)
c      write(*,*) (nscoor(j,i),j=1,4)
      enddo
      close(10)
c       sort the selnode depend the sn=2 column
      sn=2
      call sortselnode(nns,mns,sn,nscoor)

      open(40,file='selnode.sort',status='unknown',form='formatted')
      write(40,*) 'selnode after sort'
      write(40,*) nns, mns
      do i=1,nns
      write(40,1600) (nscoor(j,i),j=1,4)
      enddo
      close(40)
  
c        write(*,*)np2,nlayer
c        write(*,*)i-1,nleft(i-1),u0(1,nleft(i-1)),u0(1,nleft(i-1))
c        write(*,*)i-1,nright(i-1),u0(1,nright(i-1)),u0(2,nright(i-1))


1000  format(i9,2f15.5,20es15.5)
1100  format(i9,20es15.5)
1200  format(10i9)
1300  format(2i9,10es13.5)
1400  format(i9,2f13.3,f13.1)      
1500  format(i9,3i10.3,f13.1)      
1600  format(i9,3i10.3)      
      end

      subroutine sortselnode(nns,mns,sn,nscoor)
      implicit real*8 (a-h,l,o-z)
      
      dimension nscoor(4,1000000)
      integer i,j,k,nns,mns,sn
      real temp
          
c      do i=1,nns
c      write(*,*) (nscoor(j,i),j=1,4)
c      enddo
c      write(*,*) nns,mns,sn
      do i=1, (nns-1)
        do j=(i+1),nns
c           write(*,*) nscoor(sn,i),nscoor(sn,j)
           if (nscoor(sn,i).gt.nscoor(sn,j)) then
c           if 1.gt.2 then
c          exchange the row i and j
c                write(*,*) 'test'
                do k=1,mns
                    temp=nscoor(k,i)
                    nscoor(k,i)=nscoor(k,j)
                    nscoor(k,j)=temp
                enddo           
           end if
        enddo  
      enddo

      end
