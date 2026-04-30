import React from 'react'
import { Blocks } from 'react-loader-spinner'

const Loader = () => {
    return (
        <div>
            <h1>PLEASE WAIT...</h1>
            <Blocks
                height="80"
                width="80"
                color="#4fa94d"
                ariaLabel="blocks-loading"
                wrapperStyle={{}}
                wrapperClass="blocks-wrapper"
                visible={true}
            />
        </div>
    )
}

export default Loader