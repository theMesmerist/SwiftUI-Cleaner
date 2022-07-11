//
//  File.swift
//  storage
//
//  Created by Destan Keskinkılıç on 27.01.2022.
//

import Foundation
import UIKit


class DiskInformation: NSObject {

    var totalSpaceInBytes: CLongLong = 0; // total disk space
    var totalFreeSpaceInBytes: CLongLong = 0; //total free space in bytes

    func getTotalDiskSpace() -> String { //get total disk space
        do{
        let space: CLongLong = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemSize] as! CLongLong; //Check for home dirctory and get total system size
            totalSpaceInBytes = space; // set as total space
            return memoryFormatter(space: space); // send the total bytes to formatter method and return the output

        }catch let error{ // Catch error that may be thrown by FileManager
            print("Error is ", error);
        }
        return "Error while getting memory size";
    }

    func getTotalFreeSpace() -> String{ //Get total free space
        do{
            let space: CLongLong = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemFreeSize] as! CLongLong;
            totalFreeSpaceInBytes = space;
            return memoryFormatter(space: space);

        }catch let error{
            print("Error is ", error);
        }
        return "Error while getting memory size";
    }

    func getTotalUsedSpace() -> String{ //Get total disk usage from above variable
        return memoryFormatter(space: (totalSpaceInBytes - totalFreeSpaceInBytes));
    }

    func memoryFormatter(space : CLongLong) -> String{ //Format the usage to return value with 2 digits after decimal
        var formattedString: String;

        let totalBytes: Double = 1.0 * Double(space);
        let totalMb: Double = totalBytes / (1024 * 1024);
        let totalGb: Double = totalMb / 1024;
        if (totalGb > 1.0){
            formattedString = String(format: "%.2f", totalGb);
        }else if(totalMb >= 1.0){
            formattedString = String(format: "%.2f", totalMb);
        }else{
            formattedString = String(format: "%.2f", totalBytes);
        }
        return formattedString;
    }


}
