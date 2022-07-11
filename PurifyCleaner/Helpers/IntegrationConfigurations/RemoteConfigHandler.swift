


import Foundation
import Firebase



class RemoteConfigOperations{
    
    func configure_remote_config_operations(){
        
        
        setup_remoteConfig_defaults()
        fetch_remoteConfig_values()
        set_remoteConfig_values()
    
        
    }
    
    func setup_remoteConfig_defaults(){
        
        let defaultValues = [
            "selectedMMP" : "adjust" as NSObject,
        ]
        
        RemoteConfig.remoteConfig().setDefaults(defaultValues)
        
    }
    
    func fetch_remoteConfig_values(){
        
        
   
        RemoteConfig.remoteConfig().fetch(){ (status, error) in
            guard error == nil else{
                print(error?.localizedDescription ?? "" )
                return
        }
            RemoteConfig.remoteConfig().activate { changed, error in
                self.set_remoteConfig_values()
            }
          
    }
      
        
       
            
    }
    
    func set_remoteConfig_values(){
        
    
        
    
        let str_selectedMMP = RemoteConfig.remoteConfig().configValue(forKey: "selectedMMP").stringValue ?? "adjust"
        
        switch str_selectedMMP {
        case "adjust":
            selectedMMP = .adjust
        case "branch":
            selectedMMP = .branch
        case "appMetrica":
            selectedMMP = .appMetrica
        default:
            selectedMMP = .adjust
        }
        
    }
    
    
    
    

    
}
