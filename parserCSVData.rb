
require 'csv'
require 'time'

def parserCSVperfdata(filename)

  h = {};
  h_count = {}
  result = [];
  i =0;
  CSV.foreach(filename) do |rec|
    if (h.has_key?(rec[2]))
      h[rec[2]] = h[rec[2]].to_i + rec[1].to_i
      h_count[rec[2]] = h_count[rec[2]].to_i + 1
      next;

    else 
      h[rec[2]] = rec[1]
      h_count[rec[2]] = h_count[rec[2]].to_i + 1

    end
  end
  
  h.each_key { |key|  
    h[key] = h[key].to_i/h_count[key].to_i
    result[i] = key;
    result[i+1] = ",";
    result[i+2] = h[key];
    result[i+3] = "\n";
    i=i+4
  }
  return h.sort;
end

def insertlog(src,dest)
  # get current date and collect the data today
  t = Time.now
  cdate = t.strftime("%Y-%m-%d")
  
  #append row to CSV file, using Ruby1.9 here for mode = 'a'
  csvwriter = CSV.open(dest,'a')
  csvwriter << cdate.split
  src.each do |row|
    csvwriter << row
  end
end


t = Time.now
mdate = t.strftime("%Y%m%d")

aggresultfile = "D://Perf//loadtest.csv";

# Generate JMeter agg result on daily bases
arraydir = Dir.entries("D://tools//jakarta-jmeter-2.4//bin");
arraydir.each { |item|
	 item.scan(/#{mdate}_[0-9]+_rawdata\.csv/) { |match| 
		aggdata = parserCSVperfdata("D://tools//jakarta-jmeter-2.4//bin//#{match}");
		insertlog(aggdata,aggresultfile); 
	}
}