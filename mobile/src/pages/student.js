import React, { useRef } from 'react';
import { Button, Text, View, Image } from 'react-native';
import { Form } from '@unform/mobile';
import Input from './components/Form/Input';
import styles from './studentStyle'
import globalstyle from './globalstyle'
import img from '../../assets/splash.png'
import api from '../services/api';

export default function SignIn() {
  const formRef = useRef(null);

  async function routes_newstudent(data) {
    console.log('x')
    console.log(data)
//    data.preventDefault()

    const { name_pers, address_pers, email_pers } = data

//    try {
      await api.post('routes_newstudent',{ name_pers, address_pers, email_pers})
     
    //} catch (err) {
//      alert('Erro ao cadastrar aluno, tente novamente.')
    //}
  }

  return (
    <View style={globalstyle.container}>
         <Image source= {img} />
        <View style={styles.forms}>
            <Form ref={formRef} onSubmit={routes_newstudent}>
                <Text style={styles.inputLabel}>Nome do Aluno</Text>
                <Input style={styles.inputText} name="name_pers" type="text" />

                <Text style={styles.inputLabel}>Endereço</Text>       
                <Input style={styles.inputText} name="address_pers" type="email" />

                <View style={styles.CidyContainer}>
                    <View style={{width:'68%'}}>
                        <Text style={styles.inputLabel}>Cidade</Text>       
                        <Input style={[styles.inputText]} name="city_pers" type="text" />
                    </View>

                    <View style={{backgroundColor: '#fff', width: '30%', marginLeft: '2%'}}>
                        <Text style={styles.inputLabel}>Cep</Text>       
                        <Input style={styles.inputText} name="zipcode_pers" type="text" />
                    </View>
                </View>






                <Button title="Gravar" onPress={() => formRef.current.submitForm()} />
            </Form>
        </View>
    </View>
  );
}
 