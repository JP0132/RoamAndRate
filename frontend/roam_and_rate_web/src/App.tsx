import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from './assets/vite.svg'
import heroImg from './assets/hero.png'
import './App.css'
import axios from 'axios'


function App() {

  const server_url = "http://192.168.1.165:8003";

  const [userData, setUserData] = useState(null);

  axios.get(server_url + "/getUsersData").then((response) => {
    setUserData(response.data);
    console.log(response.data);
  });




 
  
  return (
    <>
      <div>
        <h1>Roam&Rate</h1>
      </div>
      <div>
        <p>{userData}</p>
        
      </div>
    </>
  )
}

export default App
