struct Voxelize
(
	m_voxels = #(),
	m_voxelCount = 10,
	
	fn GetLongestSide obj =
	(
		s = obj.max - obj.min
		a = #(s.x, s.y, s.z)
		return amax a
	),
	
	fn GridSlice obj =
	(
		l = this.GetLongestSide obj
		l2 = l/2.0
		voxSize = l / (this.m_voxelCount-1)
		
		for i=1 to 3 do
		(
			for j=1 to this.m_voxelCount do
			(
				v = -l2 + (j-1) * voxSize
				sm = SliceModifier()
				if i == 1 do
				(
					sm.slice_plane.position = [0,0,v]
					sm.slice_plane.rotation = (EulerAngles 0 90 0) as quat
				)
				if i == 2 do
				(
					sm.slice_plane.position = [0,0,v]
					sm.slice_plane.rotation = (EulerAngles 0 0 0) as quat
				)
				if i == 3 do
				(
					sm.slice_plane.position = [0,0,v]
					sm.slice_plane.rotation = (EulerAngles 90 0 0) as quat
				)
				addModifier obj sm
			)
		)
	),
	
	fn GenerateVoxels obj =
	(
		obj = convertToMesh obj
		vs = vol__select()
		if (obj.modifiers[1]) == undefined do
		(
			addModifier obj vs
		)
		if (classof obj.modifiers[1]) == vol__Select do
		(
			vs = obj.modifiers[1]
		)
		
		l = this.GetLongestSide obj
		l2 = l/2.0
		voxSize = l / (this.m_voxelCount-1)
		voxSize2 = voxSize / 2.0
		pos = [0,0,0]
		for z=1 to this.m_voxelCount do
		(
			pos.z = (z-1) * voxSize
			for y=1 to this.m_voxelCount do
			(
				pos.y = (y-1) * voxSize
				for x=1 to this.m_voxelCount do
				(
					pos.x = (x-1) * voxSize
					
					b = box()
					b.position = obj.center - l2 + pos - [0,0,voxSize2]
					b.width = b.length = b.height = voxSize
					vs.level = 2
					vs.volume = 3
					vs.node = b
					vs.type = 1
					if (obj.selectedFaces.count) <= 0 do
					(
						delete b
					)
				)
			)
		)
	)
)

vox = Voxelize()
vox.GridSlice selection[1]
vox.GenerateVoxels selection[1]