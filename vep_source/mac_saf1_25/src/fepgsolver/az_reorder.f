C
C     This stuff comes from George & Liu. It basically corresponds
C     to computing a Reverse Cuthill-McKee Ordering corresponding
C     to the graph of a matrix.
C
      subroutine rcm(root,xadj,adjncy,mask,perm,ccsize,deg)
C-----------------------------------------------------------------
C-----------------------------------------------------------------
      integer adjncy(1),deg(1),mask(1),perm(1),xadj(1)
      integer ccsize,fnbr,i,j,jstop,jstrt,k,l,lbegin
     .,              lnbr,lperm,lvlend,nbr,node,root
C
      call degree(root,xadj,adjncy,mask,deg,ccsize,perm)
C
      mask(root) = 0
      if(ccsize.le.1) return
      lvlend = 0
      lnbr = 1
C
100   lbegin = lvlend + 1
C
      lvlend = lnbr
C
      do 600 i = lbegin, lvlend
      node     = perm(i)
      jstrt    = xadj(node)
      jstop    = xadj(node+1) - 1
      fnbr     = lnbr + 1
C
         do 200 j   = jstrt, jstop
         nbr        = adjncy(j)
         if(mask(nbr).eq.0) go to 200
         lnbr       = lnbr + 1
         mask(nbr)  = 0
         perm(lnbr) = nbr
200      continue
C
      if(fnbr.ge.lnbr) go to 600
      k        = fnbr
C
300   l        = k
C
      k        = k + 1
      nbr      = perm(k)
C
400   if(l.lt.fnbr) go to 500
C
      lperm    = perm(l)
      if(deg(lperm).le.deg(nbr)) go to 500
      perm(l + 1) = lperm
      l        = l - 1
      go to 400
C
500   perm(l + 1) = nbr
C
      if(k.lt.lnbr) go to 300
600   continue
C
      if(lnbr.gt.lvlend) go to 100
      k = ccsize/2
      l = ccsize
C
      do 700 i = 1, k
      lperm    = perm(l)
      perm(l)  = perm(i)
      perm(i)  = lperm
      l        = l-1
700   continue
C
C
      return
      end
      subroutine degree(root,xadj,adjncy,mask,deg,ccsize,ls)
C------------------------------------------------------------------
C------------------------------------------------------------------
      integer adjncy(1),deg(1),ls(1),mask(1),xadj(1)
      integer ccsize,i,ideg,j,jstop,jstrt,lbegin
     .,              lvlend,lvsize,nbr,node,root
C
      ls(1) = root
      xadj(root) = -xadj(root)
      lvlend = 0
      ccsize = 1
C
100   lbegin = lvlend + 1
C
      lvlend = ccsize
      do 400 i = lbegin, lvlend
      node     = ls(i)
      jstrt    = -xadj(node)
      jstop    = iabs(xadj(node+1))-1
      ideg     = 0
      if(jstop.lt.jstrt) go to 300
C
        do 200 j = jstrt, jstop
        nbr      = adjncy(j)
      if(mask(nbr).eq.0) go to 200
      ideg       = ideg + 1
      if(xadj(nbr).lt.0) go to 200
      xadj(nbr)  = -xadj(nbr)
      ccsize     = ccsize + 1
      ls(ccsize) = nbr
200   continue
C
300   deg(node) = ideg
C
400   continue
C
      lvsize = ccsize - lvlend
      if(lvsize.gt.0) go to 100
C
      do 500 i   = 1, ccsize
      node       = ls(i)
      xadj(node) = - xadj(node)
500   continue
C
C
      return
      end
      subroutine fnroot(root,xadj,adjncy,mask,nlvl,xls,ls)
C---------------------------------------------------------------------
C---------------------------------------------------------------------
      integer adjncy(1),ls(1),mask(1),xls(1),xadj(1)
      integer ccsize,j,jstrt,k,kstop,kstrt,mindeg,nabor,ndeg
     .,                                nlvl,node,nunlvl,root
C
      call rootls(root,xadj,adjncy,mask,nlvl,xls,ls)
C
      ccsize = xls(nlvl + 1) - 1
      if(nlvl.eq.1 .or.nlvl.eq.ccsize)return
C
100   jstrt = xls(nlvl)
C
      mindeg = ccsize
      root = ls(jstrt)
      if(ccsize.eq.jstrt) go to 400
C
      do 300 j = jstrt, ccsize
      node     = ls(j)
      ndeg     = 0
      kstrt    = xadj(node)
      kstop    = xadj(node + 1) - 1
C
         do 200 k = kstrt, kstop
         nabor    = adjncy(k)
         if(mask(nabor).gt.0) ndeg = ndeg + 1
200      continue
C
      if(ndeg.ge.mindeg) go to 300
      root     = node
      mindeg   = ndeg
300   continue
C
400   call rootls(root,xadj,adjncy,mask,nunlvl,xls,ls)
C
      if(nunlvl.le.nlvl) return
      nlvl = nunlvl
      if(nlvl.lt.ccsize) go to 100
C
C
      return
      end
      subroutine rootls(root,xadj,adjncy,mask,nlvl,xls,ls)
C----------------------------------------------------------------------
C----------------------------------------------------------------------
      integer adjncy(1) ,ls(1),mask(1),xls(1),xadj(1)
      integer i,j,jstop,jstrt,lbegin,ccsize,lvlend,lvsize
     .,                                nbr,nlvl,node,root
C
      mask(root) = 0
      ls(1) = root
      nlvl = 0
      lvlend = 0
      ccsize = 1
C
200   lbegin = lvlend+1
C
      lvlend = ccsize
      nlvl = nlvl + 1
      xls(nlvl)= lbegin
C
      do 400 i = lbegin, lvlend
      node     = ls(i)
      jstrt    = xadj(node)
      jstop    = xadj(node + 1) - 1
      if(jstop.lt.jstrt) go to 400
C
         do 300 j   = jstrt, jstop
         nbr        = adjncy(j)
         if(mask(nbr).eq.0) go to 300
         ccsize     = ccsize + 1
         ls(ccsize) = nbr
         mask(nbr)  = 0
300      continue
C
400   continue
      lvsize = ccsize - lvlend
      if(lvsize.gt.0) go to 200
      xls(nlvl + 1) = lvlend + 1
C
      do 500 i   = 1, ccsize
      node       = ls(i)
      mask(node) = 1
500   continue
C
C
      return
      end
