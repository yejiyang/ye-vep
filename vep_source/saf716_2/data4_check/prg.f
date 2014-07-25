      program d3xyz
      open(10,file='coor0',form='unformatted',status='unknown')
      open(999,file='coor000',form='formatted',status='unknown')
      call coor0
      write(*,*)'call coor0 success'
c        pause
      close(999)
      close(10)
      open(10,file='id0',form='unformatted',status='unknown')
      open(999,file='id000',form='formatted',status='unknown')
      call id0
      write(*,*)'call id0 success'
c        pause
      close(999)
      close(10)
      open(10,file='disp0',form='unformatted',status='unknown')
      open(999,file='disp000',form='formatted',status='unknown')
      call disp0
      write(*,*)'call disp0 success'
c        pause
      close(999)
      close(10)
      open(10,file='tli0',form='unformatted',status='unknown')
      open(999,file='tli000',form='formatted',status='unknown')
      call tli0
      write(*,*)'call tli0 success'
c        pause
      close(999)
      close(10)
      open(10,file='elem0',form='unformatted',status='unknown')
      open(999,file='elem000',form='formatted',status='unknown')
      call w6m0
      write(*,*)'call w6m0 success'
c        pause
      call mate0
      write(*,*)'call mate0 success'
c        pause
      call lq4g20
      write(*,*)'call lq4g20 success'
c        pause
      call bf0
      write(*,*)'call bf0 success'
c        pause
      close(999)
      close(10)
      end
      subroutine coor0
      implicit real*8 (a-h,o-z)
      common /nxy/ nz,nn,nnode,ntri,itri(9,100000),mat(100000),nnode1
      common /xy/ xt(100000),yt(100000)      
      common /mat/ pee(100000),pvv(100000),yitaa(100000),stiff(100000)
      common /xy1/ press,faz(1000),fax(1000),fay(1000)
      common /coor / x(100000),y(100000),z(100000)
      integer n
c       nnode: the total number of node for 2D
c       nn : the total number of node for 3D 
c       nn = nnode * nz
c       ntri : the total number of element; 2-D Quadrilateral node
c       mat(100000): label the type of material for one each element
c       xt(100000),yt(nnode)  the (x,y) of node for 2D
c       x(100000),y(100000),z(100000), the (x,y,z) of node for 3D
c
c       just for test        
        character(30) s_stif1, s_stif2

      open(121,file='data',form='formatted',status='old')
      read(121,*) nnode
      do i=1,nnode
      read(121,*) ii,xt(i),yt(i)
      enddo

c      do i=1,nnode
c      if(yt(i).lt.100) yt(i)=-200000.d0
c      if(yt(i).gt.1649900) yt(i)=1850000.d0
c      enddo

      read(121,*) ntri
      do i=1,ntri
      read(121,*) ii,itri(1,i),itri(2,i),itri(3,i),itri(4,i),
     *mat(i)
      enddo
      close(121)
      open(122,file='prg.dat',form='formatted',status='old')
      read(122,*) stif1, s_stif1
         write(*,*) '***begin*****the input material parameter*********'
         write(*,*) s_stif1,'=', stif1
      read(122,*) stif2, s_stif2
       write(*,*) s_stif2,'=', stif2
c     need to man_input the total material numbers, 30, here
        write(*,*)'pe   ','pv    ','yita         '
      do i=1,30
      read(122,*) pee(i),pvv(i),yitaa(i)
       write(*,*) pee(i),pvv(i),yitaa(i)
      enddo
         write(*,*) '*****end****the input material parameter*********'
      close(122)
c       total nzi-1=8-1 layers
c       the bottom three layers, each layer 10km=dz
c       the upper four layers, each layer 5km=dz/2
c       dz=10km each layers's depth
c       total depth 60.d3 m
      nz=8
      nh=60.d3
      dz=10.d3
        write(*,*)'total layers',nz-1,'total depth',nh
c     **********2D -> 3D, creat nodes****************************
      n=0
      do j=1,nz
      do i=1,nnode
      n=n+1
      x(n)=xt(i)
      y(n)=yt(i)
c       the upper 4 layers each depth=dz/2
c       the 'j<5' '30.d3' 'j-4' should be relative change
        if (j <5) then
        z(n)=0.d0+(j-1)*dz
        else 
        z(n)=0.d0+30.d3+(j-4)*dz/2
        end if
      enddo
      enddo
        write(*,*)'test n 1, total 3D node number', n
c      do i=1,nnode*5
c      if (y(i).ge.490000) y(i)=y(i)+200000
c      if (y(i).ge.470000) y(i)=y(i)+100000
c      if (y(i).ge.30000) y(i)=y(i)+100000
c      if (y(i).ge.10000) y(i)=y(i)+200000
c      enddo
      n=nnode*nz
        write(*,*)'test n 2, total 3D node number', n
      nn=nnode*nz
        write(*,*)'test n 3, total 3D node number', nn
c       mtij: total 3D nodes
c       mtik: =3  3D
      mtij=n 
      mtik=  3
      write(10) mtij,mtik,
     *(x(mtii),y(mtii),z(mtii),mtii=1,n)
      write(999,*) 'write begin coor0()'
      write(999,*) mtij,mtik
      write(999,*) (x(mtii),y(mtii),z(mtii),mtii=1,n)
      write(999,*) 'write end coor0()'
      return
      end
 
      subroutine id0
      implicit real*8 (a-h,o-z)
      common /nxy/ nz,nn,nnode,ntri,itri(9,100000),mat(100000),nnode1
      common /xy/ xt(100000),yt(100000)      
      common /mat/ pee(100000),pvv(100000),yitaa(100000),stiff(100000)
      common /xy1/ press,faz(1000),fax(1000),fay(1000)
      common /id / idu(100000),idv(100000),idw(100000)
      common /coor / x(100000),y(100000),z(100000)
      integer n,idu,idv,idw
      do  5 i=1,nn
      n=i
c      if (n.le.0) goto  5
      idu(n)=1
      idv(n)=1
      idw(n)=1
   5  continue
c       the following loop just change the surface nodes' idw=-1
      do  6 i=1,nnode
      n=i
c      if (n.le.0) goto  6
      idu(n)=1
      idv(n)=1
      idw(n)=-1
   6  continue
c      open(88,file='test2',form='formatted',status='unknown')
c        write(88,*)'n=',n,'nnode=',nnode
c        write(88,*)(idu(i88),idv(i88),idw(i88),i88=1,nnode)
c      close(88)

      open(11,file='boundaries',status='old')
      mbb=1000
c         write(*,*)'surrounding sides',mbb
      do i=1,mbb
      read(11,*,end=37)ia,ib,ic,idx,idy,idm
c        write(*,*)i,ic,idx,idy,idm
        do j=1,ic
        read(11,*)ia,k1,k2
         if(idx.eq.-1) idu(k1)=-1
         if(idy.eq.-1) idv(k1)=-1
         if(idx.eq.-1) idu(k2)=-1
         if(idy.eq.-1) idv(k2)=-1
c         write(*,*)'j ',k1,idu(k1),idv(k1)
        enddo
      enddo
37      close(11)

      do iz=1,nz
      do i=1,nnode
      k=i+(iz-1)*nnode
      idw(k)=1
      if(iz.eq.1)idw(k)=-1
      idu(k)=idu(i)
      idv(k)=idv(i)
      enddo
      enddo

      n=nn
      mtij=n
      mtik=  3
      write(10) mtij,mtik,
     *(idu(mtii),idv(mtii),idw(mtii),mtii=1,n)
      write(999,*) 'write begin id0()'
      write(999,*) mtij,mtik,
     *(idu(mtii),idv(mtii),idw(mtii),mtii=1,n)
      write(999,*) 'write end id0()'
      return
      end
 
      subroutine disp0
      implicit real*8 (a-h,o-z)
      common /nxy/ nz,nn,nnode,ntri,itri(9,100000),mat(100000),nnode1
      common /xy/ xt(100000),yt(100000)      
      common /mat/ pee(100000),pvv(100000),yitaa(100000),stiff(100000)
      common /xy1/ press,faz(1000),fax(1000),fay(1000)
      common /disp / u(500000),v(500000),w(500000)
      integer n
      common /coor/x(100000),y(100000),z(100000)

      dimension xtt(500000),ytt(500000),r(3)
      dimension idu(500000),idv(500000),idw(500000)
      common/bdline/nop,Lin,p(1000,4),Ln(1000,2)
            
      do 22 i=1,nn
      n=i
c      if (n.le.0) goto 22
      u(n)=0.0
      v(n)=0.0
      w(n)=0.0
  22  continue

      OPEN (11,file='id0',form='unformatted',status='unknown')
      read(11) mtij,mtik,
     *(idu(i),idv(i),idw(i),i=1,mtij)
      close(11)

        open(11,file='mesh.cor',status='old')
        read(11,*)np
        do i=1,np
        read(11,*)xtt(i),ytt(i)
        enddo
        close (11)

        open(11,file='t2.dat',status='old')
        read(11,*)nop
        do i=1,nop
        read(11,*)m,p(i,1),p(i,2)
        p(i,3)=0.
        p(i,4)=0.
        enddo
        read(11,*)num
        do i=1,num
        read(11,*)
        enddo
        read(11,*)Lin
        do i=1,Lin
        read(11,*)m,Ln(i,1),Ln(i,2)
        enddo
        close (11)
        
        open(11,file='gps.dat',form='formatted',status='old')
        write(*,*)'********begin*****read gps data*****************'
c       only read the first 1000 lines data, if less then 1000 goto 9988
        do i=1,1000
        read(11,*,end=9988)k,p(k,3),p(k,4)
c        read(11,*)k,p(k,3),p(k,4)
        write(*,*)k,p(k,3),p(k,4)
        enddo
        write(*,*)'*****end********read gps data*****************'
        close (11)
9988    continue
        write(*,*)'*****end********read gps data*****************'

        write(*,*)'xtt(1),ytt(1),p(1,1),p(1,2),p(1,3),p(1,4) '
        write(*,*)xtt(1),ytt(1),p(1,1),p(1,2),p(1,3),p(1,4) 

        do i=1,m0
         u(i)=0.0
         v(i)=0.0
         w(i)=0.0
        enddo       
        open(31,file='disp.dat',form='formatted',status='unknown')
        do iz=1,nz
        do i=1,nnode
         k=i+(iz-1)*nnode
         r(1)=xtt(i)
         r(2)=ytt(i)
         if (idu(k).eq.-1) u(k)=bound(r,t,1)
         if (idv(k).eq.-1) v(k)=bound(r,t,2)
         w(k)=0.0
         if(iz.eq.nz) 
     *    write(31,'(i6,3es12.2)')i,u(k),v(k),sqrt(u(k)*u(k)+v(k)*v(k))
        enddo
        enddo
        close(31)

      n=nn
      mtij=n
      mtik=  3
      write(10) mtij,mtik,
     *(u(mtii),v(mtii),w(mtii),mtii=1,n)
      write(999,*) mtij,mtik,
     *(u(mtii),v(mtii),w(mtii),mtii=1,n)
      return
      end
 
      subroutine tli0
      implicit real*8 (a-h,o-z)
      common /nxy/ nz,nn,nnode,ntri,itri(9,100000),mat(100000),nnode1
      common /xy/ xt(100000),yt(100000)      
      common /mat/ pee(100000),pvv(100000),yitaa(100000),stiff(100000)
      common /xy1/ press,faz(1000),fax(1000),fay(1000)
      common /tli / dxx(100000),dyy(100000),dzz(100000),
     *dyz(100000),dxz(100000),dxy(100000)
      integer n
      do 23 i=1,nn
      n=i
      if (n.le.0) goto 23
      dxx(n)=0.0
      dyy(n)=0.0
      dzz(n)=0.0
      dyz(n)=0.0
      dxz(n)=0.0
      dxy(n)=0.0
  23  continue
      mtij=n
      mtik=  6
      write(10) mtij,mtik,
     *(dxx(mtii),dyy(mtii),dzz(mtii),dyz(mtii),
     *dxz(mtii),dxy(mtii),mtii=1,n)
      write(999,*) 'write begin tli0()'
      write(999,*) mtij,mtik,
     *(dxx(mtii),dyy(mtii),dzz(mtii),dyz(mtii),
     *dxz(mtii),dxy(mtii),mtii=1,n)
      write(999,*) 'write end  tli0()'
      return
      end
 
      subroutine w6m0
      implicit real*8 (a-h,o-z)
      common /nxy/ nz,nn,nnode,ntri,itri(9,100000),mat(100000),nnode1
      common /xy/ xt(100000),yt(100000)      
      common /mat/ pee(100000),pvv(100000),yitaa(100000),stiff(100000)
      common /xy1/ press,faz(1000),fax(1000),fay(1000)
      common /w6m / nod1(100000),nod2(100000),nod3(100000),
     *nod4(100000),nod5(100000),nod6(100000),nod7(100000),
     *nod8(100000),nod9(100000),nod10(100000),nod11(100000),
     *nod12(100000),nod13(100000),nod14(100000),nod15(100000),
     *nod16(100000),nod17(100000),nod18(100000),nod19(100000),
     *nod20(100000),nod21(100000),nod22(100000),nod23(100000),
     *nod24(100000),nod25(100000),nod26(100000),nod27(100000),
     *mate(100000)
      integer n,nod1,nod2,nod3,nod4,nod5,
     *nod6,nod7,nod8,nod9,nod10,nod11,nod12,nod13,nod14,nod15,nod16,
     *nod17,nod18,nod19,nod20,nod21,nod22,nod23,nod24,nod25,nod26,
     *nod27,mate
c      do i=1,ntri
c      if (mat(i).eq.6) mat(i)=5
c      enddo
c      do i=1,ntri
c      if (mat(i).eq.7) mat(i)=5
c      enddo
c
c       mat +10, the 10  means one layers' maximum mattypes
      do j=1,7
      do i=1,ntri
      n=(j-1)*ntri+i
      nod1(n)=itri(1,i)+nnode*(j-1)
      nod2(n)=itri(2,i)+nnode*(j-1)
      nod3(n)=itri(3,i)+nnode*(j-1)
      nod4(n)=itri(4,i)+nnode*(j-1)
      nod5(n)=itri(1,i)+nnode*j
      nod6(n)=itri(2,i)+nnode*j
      nod7(n)=itri(3,i)+nnode*j
      nod8(n)=itri(4,i)+nnode*j
        if ((j>=1).and. (j<=3)) then
c       the first bottom 3 layers as 1 mat_layer,mat_number=mat+20  
           mate(n)=mat(i)+20
        else if ((j>=4) .and. (j<=5)) then
c       the second mat_layer(4&5layer), mat + 10 
           mate(n)=mat(i)+10
        else if ((j>=6) .and. (j<=7)) then
c       the third mat_layer(6&7layer), mat 
           mate(n)=mat(i)
        end if
      enddo
      enddo
c     n: total elements, 7 means 7layers
c     n= ntri * 7      
      n=ntri*7
      mtij=n
c     mtik=9; each line 9 colums number, 8 nodes 1 mat
      mtik=  9
      write(10) mtij,mtik,
     *(nod1(mtii),nod2(mtii),nod3(mtii),nod4(mtii),
     *nod5(mtii),nod6(mtii),nod7(mtii),nod8(mtii),
     *mate(mtii),mtii=1,n)
      write(999,*) 'write begin w6m0 '
      write(999,*) mtij,mtik
      write(*,*) 'test*****************',mtij,mtik
      write(999,*) 
     *(nod1(mtii),nod2(mtii),nod3(mtii),nod4(mtii),
     *nod5(mtii),nod6(mtii),nod7(mtii),nod8(mtii),
     *mate(mtii),mtii=1,n)
      write(999,*) 'write end  w6m0 '
      return
      end
 
      subroutine mate0
      implicit real*8 (a-h,o-z)
      common /nxy/ nz,nn,nnode,ntri,itri(9,100000),mat(100000),nnode1
      common /xy/ xt(100000),yt(100000)      
      common /mat/ pee(100000),pvv(100000),yitaa(100000),stiff(100000)
      common /xy1/ press,faz(1000),fax(1000),fay(1000)
      common /mate / pe(100000),pv(100000),fx(100000),
     *fy(100000),fz(100000),rou(100000),alpha(100000),
     *yita(100000)
      integer n
      do i=1,30
      n=i
      pe(n)=pee(i)
      pv(n)=pvv(i)
      fx(n)=0.
      fy(n)=0.
      fz(n)=0.
      rou(n)=0.
      alpha(n)=0.
      yita(n)=yitaa(i)
      enddo
      
      mtij=n
      mtik=  8
      write(10) mtij,mtik,
     *(pe(mtii),pv(mtii),fx(mtii),fy(mtii),
     *fz(mtii),rou(mtii),alpha(mtii),yita(mtii)
     *,mtii=1,n)
      write(999,*) 'write begin mate0()'
      write(999,*) mtij,mtik,
     *(pe(mtii),pv(mtii),fx(mtii),fy(mtii),
     *fz(mtii),rou(mtii),alpha(mtii),yita(mtii)
     *,mtii=1,n)
      write(999,*) 'write end mate0()'
      return
      end
 
      subroutine lq4g20
      implicit real*8 (a-h,o-z)
      common /nxy/ nz,nn,nnode,ntri,itri(9,100000),mat(100000),nnode1
      common /xy/ xt(100000),yt(100000)      
      common /mat/ pee(100000),pvv(100000),yitaa(100000),stiff(100000)
      common /xy1/ press,faz(1000),fax(1000),fay(1000)
      common /lq4g2 / nod1(100000),nod2(100000),nod3(100000),
     *nod4(100000),mate(100000)
      integer n,nod1,nod2,nod3,nod4,mate
      do 32 j=1,1
      do 31 i=1,1
      n=(j-1)*nz+i
      if (n.le.0) goto 31
      nod1(n)=itri(1,i)
      nod2(n)=itri(2,i)
      nod3(n)=itri(3,i)
      nod4(n)=itri(4,i)
      mate(n)=1
  31  continue
  32  continue
      mtij=n
      mtik=  5
      write(10) mtij,mtik,
     *(nod1(mtii),nod2(mtii),nod3(mtii),nod4(mtii),
     *mate(mtii),mtii=1,n)
      write(999,*)'write begin lq4g20'
      write(999,*) mtij,mtik,
     *(nod1(mtii),nod2(mtii),nod3(mtii),nod4(mtii),
     *mate(mtii),mtii=1,n)
      write(999,*)'write end lq4g20'
      return
      end
 
      subroutine bf0
      implicit real*8 (a-h,o-z)
      common /nxy/ nz,nn,nnode,ntri,itri(9,100000),mat(100000),nnode1
      common /xy/ xt(100000),yt(100000)      
      common /mat/ pee(100000),pvv(100000),yitaa(100000),stiff(100000)
      common /xy1/ press,faz(1000),fax(1000),fay(1000)
      common /bf / fx(100000),fy(100000),fz(100000)
      integer n
      n=1
      fx(n)=0.0
      fy(n)=0.0
      fz(n)=0.0
      mtij=n
      mtik=  3
      write(10) mtij,mtik,
     *(fx(mtii),fy(mtii),fz(mtii),mtii=1,n)
      write(999,*) 'write begin bf0'
      write(999,*) mtij,mtik,
     *(fx(mtii),fy(mtii),fz(mtii),mtii=1,n)
      write(999,*) 'write end bf0'
      return
      end

      real*8 function bound(r,t,j)
      implicit real*8 (a-h,o-z)
       common/bdline/nop,Lin,p(1000,4),Ln(1000,2)

c      implicit  (a-h,o-z)
      dimension r(2)
      bound=0.0

      do i=1,Lin
      k1=Ln(i,1)
      k2=Ln(i,2)
      call proc(p(k1,1),p(k1,2),p(k1,3),p(k1,4),
     # p(k2,1),p(k2,2),p(k2,3),p(k2,4),r(1),r(2),u3,v3,L)
      if(L.gt.0)then
      if(j.eq.1)bound=u3
      if(j.eq.2)bound=v3
      return
      endif
      enddo
c     write(*,*) 'bound =',bound
      return
      end
 
        subroutine proc(x1,y1,u1,v1,x2,y2,u2,v2,x,y,u3,v3,L)
        implicit real*8 (a-h,o-z)
        u3=0.
        v3=0.
        L=-1
        a1=x2-x1
        a2=y2-y1
        b1=x-x1
        b2=y-y1
        c1=x-x2
        c2=y-y2
        d=sqrt(a1*a1+a2*a2)
        s=abs(a1*b2-a2*b1)
        h=2*s/d
        f=b1*c1+b2*c2

        if(h.lt.0.05.and.f.le.0)then
        L=1
        d1=sqrt(b1*b1+b2*b2)
        r=d1/d
        u3=(1-r)*u1+r*u2
        v3=(1-r)*v1+r*v2
        return
        endif
        return
        end
