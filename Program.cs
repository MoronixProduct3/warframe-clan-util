using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            Regex clanR = new Regex(@"{(?:(?:""_id"":{""\$oid"":""\w{24}""}|""Name"":""[\w-_. ]{1,24}""|""Creator"":(?:true|false)|""Members"":\[(?:{(?:(?:""_id"":{""\$oid"":""\w{24}""}|""DisplayName"":""[\w-_. ]{1,24}""|""LastLogin"":{""\$date"":{""\$numberLong"":""\d{13}""}}|""Rank"":\d{1,2}|""Status"":\d+|""Joined"":{""\$date"":{""\$numberLong"":""\d{13}""}}|""ActiveAvatarImageType"":""(?:\/\w+)+""|""PlayerLevel"":\d{1,2}),?){7,8}},?){1,1000}]|""Ranks"":\[(?:{""Name"":""[\w-_. ]{1,24}"",""Permissions"":\d+},?)+]|""Tier"":\d+),?){6,}[\x20-\x7E]*}");

            int chunkSize = 500000; // Search by blocks of 1 million characters / 2
            long currentSearchIndex = 0;

            Console.WriteLine("Started");

            byte[] buffer = new byte[chunkSize*2];

            String SearchBlock;

            Dictionary<long, String> matches = new Dictionary<long, string>();

            using (FileStream reader = new FileStream("GoodClanDump.dmp", FileMode.Open, FileAccess.Read))
            {
                while ( reader.Position < reader.Length )
                {
                    // Read new chunk
                    reader.Read(buffer, chunkSize, chunkSize);

                    // Convert byte array to String
                    SearchBlock = Encoding.ASCII.GetString(buffer, 0, buffer.Length);

                    // Search for pattern in string
                    Match res = clanR.Match(SearchBlock);

                    while (res.Success)
                    {
                        matches[currentSearchIndex + res.Index] = res.Value;
                        res = res.NextMatch();
                    }

                    // Shift front of buffer to back
                    Array.Copy(buffer, chunkSize, buffer, 0, chunkSize);
                    currentSearchIndex += chunkSize;
                }
            }

            Console.WriteLine("Finished Reading");
            Console.WriteLine(matches.Count);
            Console.WriteLine("Writing Strings to file");


            foreach (KeyValuePair<long, String> hit in matches)
            {
                using (StreamWriter outputFile = new StreamWriter(".\\out_clan"+hit.Key+".txt"))
                {
                    outputFile.Write(hit.Value);
                }
            }

            Console.WriteLine("Finished");
            Console.ReadKey();
        }
    }
}
