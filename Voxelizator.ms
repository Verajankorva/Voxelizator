struct Voxelize
(
	m_voxels = #(),
	m_voxelCount = 15,
	
	fn GetLongestSide obj =
	(
		s = obj.max - obj.min
		a = #(s.x, s.y, s.z)
		return amax a
	),
	
	fn GenerateVoxels obj =
	(
		n = NormalModifier()
		n.flip = false
		if (obj.modifiers[1]) == undefined do
		(
			AddModifier obj n
		)		
		if (classof obj.modifiers[1]) == NormalModifier do
		(
			n = obj.modifiers[1]
		)
			
		r = Point()
		r.name = "Voxels"
		
		l = this.GetLongestSide obj
		l2 = l/2.0
		voxSize = l / this.m_voxelCount
		voxSizeH = voxSize / 2.0
		pos = [0,0,0]
		dirs = #([1,0,0], [0,1,0], [0,0,1], [-1,0,0], [0,-1,0], [0,0,-1])
		for z=1 to this.m_voxelCount do
		(
			zz = z - 1
			pos.z = zz * voxSize + voxSizeH
			for y=1 to this.m_voxelCount do
			(
				yy = y - 1
				pos.y = yy * voxSize + voxSizeH
				for x=1 to this.m_voxelCount do
				(
					--pnt = Point()
					--pnt.parent = r
					xx = x - 1
					pos.x = xx * voxSize + voxSizeH
					po = obj.center - l2 + [0,0,0] + pos
					--pnt.position = po
					hit = false
					for j=1 to 2 do
					(
						for i=1 to dirs.count do
						(
							ra = ray po dirs[i]
							h = intersectRay obj ra
							if h != undefined do
							(
								if (distance po h.pos) <= voxSizeH do
								(
									hit = true
									break
								)
							)
						)
						
						if hit do
						(
							break
						)
						n.flip = not n.flip
					)
					
					if hit do
					(
						p = box()
						p.width = p.length = p.height = voxSize
						p.pos = po
						p.pos.z -= voxSizeH
						p.parent = r
						append m_voxels p
					)
				)
			)
		)
	)
)

vox = Voxelize()
vox.GenerateVoxels selection[1]