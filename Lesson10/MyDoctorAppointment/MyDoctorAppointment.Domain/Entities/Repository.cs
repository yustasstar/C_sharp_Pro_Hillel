﻿namespace MyDoctorAppointment.Domain.Entities
{
	public class Repository
	{
		public Database Database { get; set; }
	}

	public class Database
	{
		public ConfigEntity Doctors { get; set; }
		public ConfigEntity Patients { get; set; }
		public ConfigEntity Appointments { get; set; }
	}

	public class ConfigEntity
	{
		public int LastId { get; set; }
		public string Path { get; set; }
	}

	//public class Appointments
	//{
	//    public int LastId { get; set; }
	//    public string Path { get; set; }
	//}

	//public class Doctors
	//{
	//    public int LastId { get; set; }
	//    public string Path { get; set; }
	//}

	//public class Patients
	//{
	//    public int LastId { get; set; }
	//    public string Path { get; set; }
	//}
}