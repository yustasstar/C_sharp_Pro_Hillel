﻿namespace InterfaceSegregationPrinciple.DeviceInterface
{
	public interface IProduct
	{
		int Id { get; set; }

		double Weight { get; set; }

		int Stock { get; set; }

		string GetFeatures();
	}
}
