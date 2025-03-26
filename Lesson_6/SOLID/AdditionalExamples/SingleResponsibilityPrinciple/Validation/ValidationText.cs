﻿namespace SingleResponsibilityPrinciple.Validation
{
	public class ValidationText
	{
		public void Validate(string textField)
		{
			if (string.IsNullOrWhiteSpace(textField))
			{
				throw new Exception("The field is empty!");
			}
		}
	}
}
