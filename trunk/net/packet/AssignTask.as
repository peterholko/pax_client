﻿package net.packet
{
	public class AssignTask implements IPacket
	{
		public var cityId:int;
		public var caste:int;
		public var race:int;
		public var amount:int;
		public var targetId:int;
		public var targetType:int;
		
		public function AssignTask() : void
		{		
		}
	}
	
}