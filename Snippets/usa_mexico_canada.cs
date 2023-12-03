using System;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        // USA States List
        List<KeyValuePair<string, string>> usaStates = new List<KeyValuePair<string, string>>
        {
            new KeyValuePair<string, string>("Alabama", "AL"),
            new KeyValuePair<string, string>("Alaska", "AK"),
            new KeyValuePair<string, string>("Arizona", "AZ"),
            new KeyValuePair<string, string>("Arkansas", "AR"),
            new KeyValuePair<string, string>("California", "CA"),
            new KeyValuePair<string, string>("Colorado", "CO"),
            new KeyValuePair<string, string>("Connecticut", "CT"),
            new KeyValuePair<string, string>("Delaware", "DE"),
            new KeyValuePair<string, string>("Florida", "FL"),
            new KeyValuePair<string, string>("Georgia", "GA"),
            new KeyValuePair<string, string>("Hawaii", "HI"),
            new KeyValuePair<string, string>("Idaho", "ID"),
            new KeyValuePair<string, string>("Illinois", "IL"),
            new KeyValuePair<string, string>("Indiana", "IN"),
            new KeyValuePair<string, string>("Iowa", "IA"),
            new KeyValuePair<string, string>("Kansas", "KS"),
            new KeyValuePair<string, string>("Kentucky", "KY"),
            new KeyValuePair<string, string>("Louisiana", "LA"),
            new KeyValuePair<string, string>("Maine", "ME"),
            new KeyValuePair<string, string>("Maryland", "MD"),
            new KeyValuePair<string, string>("Massachusetts", "MA"),
            new KeyValuePair<string, string>("Michigan", "MI"),
            new KeyValuePair<string, string>("Minnesota", "MN"),
            new KeyValuePair<string, string>("Mississippi", "MS"),
            new KeyValuePair<string, string>("Missouri", "MO"),
            new KeyValuePair<string, string>("Montana", "MT"),
            new KeyValuePair<string, string>("Nebraska", "NE"),
            new KeyValuePair<string, string>("Nevada", "NV"),
            new KeyValuePair<string, string>("New Hampshire", "NH"),
            new KeyValuePair<string, string>("New Jersey", "NJ"),
            new KeyValuePair<string, string>("New Mexico", "NM"),
            new KeyValuePair<string, string>("New York", "NY"),
            new KeyValuePair<string, string>("North Carolina", "NC"),
            new KeyValuePair<string, string>("North Dakota", "ND"),
            new KeyValuePair<string, string>("Ohio", "OH"),
            new KeyValuePair<string, string>("Oklahoma", "OK"),
            new KeyValuePair<string, string>("Oregon", "OR"),
            new KeyValuePair<string, string>("Pennsylvania", "PA"),
            new KeyValuePair<string, string>("Rhode Island", "RI"),
            new KeyValuePair<string, string>("South Carolina", "SC"),
            new KeyValuePair<string, string>("South Dakota", "SD"),
            new KeyValuePair<string, string>("Tennessee", "TN"),
            new KeyValuePair<string, string>("Texas", "TX"),
            new KeyValuePair<string, string>("Utah", "UT"),
            new KeyValuePair<string, string>("Vermont", "VT"),
            new KeyValuePair<string, string>("Virginia", "VA"),
            new KeyValuePair<string, string>("Washington", "WA"),
            new KeyValuePair<string, string>("West Virginia", "WV"),
            new KeyValuePair<string, string>("Wisconsin", "WI"),
            new KeyValuePair<string, string>("Wyoming", "WY")
        };

        // Mexico States List
        List<KeyValuePair<string, string>> mexicoStates = new List<KeyValuePair<string, string>>
        {
            new KeyValuePair<string, string>("Aguascalientes", "AG"),
            new KeyValuePair<string, string>("Baja California", "BC"),
            new KeyValuePair<string, string>("Baja California Sur", "BS"),
            new KeyValuePair<string, string>("Campeche", "CM"),
            new KeyValuePair<string, string>("Chiapas", "CS"),
            new KeyValuePair<string, string>("Chihuahua", "CH"),
            new KeyValuePair<string, string>("Coahuila", "CO"),
            new KeyValuePair<string, string>("Colima", "CL"),
            new KeyValuePair<string, string>("Durango", "DG"),
            new KeyValuePair<string, string>("Guanajuato", "GT"),
            new KeyValuePair<string, string>("Guerrero", "GR"),
            new KeyValuePair<string, string>("Hidalgo", "HG"),
            new KeyValuePair<string, string>("Jalisco", "JA"),
            new KeyValuePair<string, string>("Mexico City", "CMX"),
            new KeyValuePair<string, string>("Mexico State", "MEX"),
            new KeyValuePair<string, string>("Michoacán", "MI"),
            new KeyValuePair<string, string>("Morelos", "MO"),
            new KeyValuePair<string, string>("Nayarit", "NA"),
            new KeyValuePair<string, string>("Nuevo León", "NL"),
            new KeyValuePair<string, string>("Oaxaca", "OA"),
            new KeyValuePair<string, string>("Puebla", "PU"),
            new KeyValuePair<string, string>("Querétaro", "QT"),
            new KeyValuePair<string, string>("Quintana Roo", "QR"),
            new KeyValuePair<string, string>("San Luis Potosí", "SL"),
            new KeyValuePair<string, string>("Sinaloa", "SI"),
            new KeyValuePair<string, string>("Sonora", "SO"),
            new KeyValuePair<string, string>("Tabasco", "TB"),
            new KeyValuePair<string, string>("Tamaulipas", "TM"),
            new KeyValuePair<string, string>("Tlaxcala", "TL"),
            new KeyValuePair<string, string>("Veracruz", "VE"),
            new KeyValuePair<string, string>("Yucatán", "YU"),
            new KeyValuePair<string, string>("Zacatecas", "ZA")
        };

        // Canada Provinces and Territories List
        List<KeyValuePair<string, string>> canadaProvincesTerritories = new List<KeyValuePair<string, string>>
        {
            new KeyValuePair<string, string>("Alberta", "AB"),
            new KeyValuePair<string, string>("British Columbia", "BC"),
            new KeyValuePair<string, string>("Manitoba", "MB"),
            new KeyValuePair<string, string>("New Brunswick", "NB"),
            new KeyValuePair<string, string>("Newfoundland and Labrador", "NL"),
            new KeyValuePair<string, string>("Northwest Territories", "NT"),
            new KeyValuePair<string, string>("Nova Scotia", "NS"),
            new KeyValuePair<string, string>("Nunavut", "NU"),
            new KeyValuePair<string, string>("Ontario", "ON"),
            new KeyValuePair<string, string>("Prince Edward Island", "PE"),
            new KeyValuePair<string, string>("Quebec", "QC"),
            new KeyValuePair<string, string>("Saskatchewan", "SK"),
            new KeyValuePair<string, string>("Yukon", "YT")
        };

        // Example of how to use the lists
        Console.WriteLine("USA States:");
        foreach (var state in usaStates)
        {
            Console.WriteLine($"{state.Key} - {state.Value}");
        }

        Console.WriteLine("\nMexico States:");
        foreach (var state in mexicoStates)
        {
            Console.WriteLine($"{state.Key} - {state.Value}");
        }

        Console.WriteLine("\nCanada Provinces and Territories:");
        foreach (var province in canadaProvincesTerritories)
        {
            Console.WriteLine($"{province.Key} - {province.Value
