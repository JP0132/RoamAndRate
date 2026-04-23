import { useEffect, useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from './assets/vite.svg'
import heroImg from './assets/hero.png'
import './App.css'
import axios from 'axios'


function App() {


  const [userData, setUserData] = useState(null);

  const server_url = import.meta.env.VITE_SERVER_URL;

  console.log("Server URL:", server_url);


  useEffect(() => {

    axios.get(server_url + "/getUsersData").then((response) => {
      setUserData(response.data);
      console.log(response.data);
    });


    // return () => {
    //   second
    // }
  }, [])

  const getUserName = () => {
    const usernames = JSON.stringify(userData["users"].map((user: any) => user["username"]));
    return usernames;
  }

  

  return (
    <>
      <div>
        <h1>Roam&Rate</h1>
      </div>
      <div>
        
        <p>{userData != null ? getUserName() : "Loading..."}</p>

      </div>
    </>
  )
}

export default App


// {
//   "users": [
//     {
//       "username": "js",
//       "fullName": "jja",
//       "dob": "2004-08-19T23:00:00Z",
//       "gender": "Male",
//       "admin": true,
//       "lastUpdated": "2025-11-07T15:40:42Z",
//       "id": "e435a32d-16fe-4503-8477-f97605851bd8",
//       "createdAt": "2025-11-07T15:40:42Z",
//       "trips": [
//         {
//           "tripName": "bs",
//           "location": "vz",
//           "currency": "EUR",
//           "budget": 84,
//           "notes": null,
//           "images": null,
//           "bgColour": "default",
//           "category": "Aboard Holiday",
//           "startDate": "2025-11-04T00:00:00Z",
//           "endDate": "2025-11-07T00:00:00Z",
//           "lastUpdated": "2025-11-07T15:41:00Z",
//           "id": "0572d037-452c-4884-b4ca-c1851a55a408",
//           "createdAt": "2025-11-07T15:41:00Z",
//           "expenses": [],
//           "ratingDetails": []
//         }
//       ],
//       "participants": [
//         {
//           "name": "js",
//           "isMainUser": true,
//           "lastUpdated": "2025-11-07T15:40:43Z",
//           "id": "60292115-7b7e-42c3-bd7b-1dd35450ecea",
//           "createdAt": "2025-11-07T15:40:43Z"
//         }
//       ]
//     },
//     {
//       "username": "js",
//       "fullName": "jja",
//       "dob": "2004-08-19T23:00:00Z",
//       "gender": "Male",
//       "admin": true,
//       "lastUpdated": "2025-11-07T16:01:12Z",
//       "id": "f41172f0-51a1-4a00-b842-607b180e0e61",
//       "createdAt": "2025-11-07T16:01:12Z",
//       "trips": [],
//       "participants": [
//         {
//           "name": "js",
//           "isMainUser": true,
//           "lastUpdated": "2025-11-07T16:01:12Z",
//           "id": "4b971592-25ac-4287-a2eb-1fd6bef51e36",
//           "createdAt": "2025-11-07T16:01:12Z"
//         }
//       ]
//     },
//     {
//       "username": "test1",
//       "fullName": "test1",
//       "dob": "2005-10-05T23:00:00Z",
//       "gender": "Male",
//       "admin": true,
//       "lastUpdated": "2025-10-29T11:26:40Z",
//       "id": "75f1b1d1-57af-4374-ad8a-c457aadc27e5",
//       "createdAt": "2025-10-29T11:26:40Z",
//       "trips": [],
//       "participants": []
//     },
//     {
//       "username": "jj12",
//       "fullName": "jj",
//       "dob": "2005-08-18T23:00:00Z",
//       "gender": "Male",
//       "admin": true,
//       "lastUpdated": "2025-10-29T12:44:52Z",
//       "id": "65fc245b-54ae-40c8-826c-505781bc58b9",
//       "createdAt": "2025-10-29T12:44:52Z",
//       "trips": [],
//       "participants": [
//         {
//           "name": "jj12",
//           "isMainUser": true,
//           "lastUpdated": "2025-10-29T12:44:53Z",
//           "id": "364c38e2-55bb-43c6-b124-710d07ec6c19",
//           "createdAt": "2025-10-29T12:44:53Z"
//         }
//       ]
//     }
//   ]
// }