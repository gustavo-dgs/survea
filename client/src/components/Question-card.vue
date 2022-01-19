<template>

  <div class="question-card question_list__question-card">
        <h2 class="question-card__title">Question title</h2>
        <hr/>
        <p class="question-card__text">
        Some quick example text to build on the card title and make up the
        bulk of the card's content.
        </p>

        <form v-if="questionType === 'select'" class="question-form question-form_type_select">
            <select class="input select">
                <option class="select_opction" value="volvo">Volvo</option>
                <option class="select_opction" value="saab">Saab</option>
                <option class="select_opction" value="fiat">Fiat</option>
                <option class="select_opction" value="audi">Audi</option>
            </select>
        </form>

        <form v-else-if="questionType === 'textarea'" class="question-form question-form_type_textarea">
            <textarea class="input textarea" placeholder="Escriba su respuesta"></textarea>
        </form>

        <form v-else-if="questionType === 'checkbox'" class="question-form question-form_type_checkbox">
            <input class="input checkbox" type="checkbox" value="1">
            <label for="1">1</label><br>
            <input class="input checkbox" type="checkbox" value="2">
            <label for="2">2</label><br>
            <input class="input checkbox" type="checkbox" value="3">
            <label for="3">3</label><br>
        </form>

        <form v-else-if="questionType === 'date'" class="question-form question-form_type_date">
            <input class="input date" type="date">
        </form>

        <form v-else-if="questionType === 'email'" class="question-form question-form_type_email">
            <input class="input email" type="email">
        </form>

        <form v-else-if="questionType === 'number'" class="question-form question-form_type_number">
            <input class="input number" type="number">
        </form>

        <form v-else-if="questionType === 'radio'" class="question-form question-form_type_radio">
            <input class="input radio" name="some_name" type="radio" value="1">
            <label for="1">1</label><br>
            <input class="input radio" name="some_name" type="radio" value="2">
            <label for="2">2</label><br>
            <input class="input radio" name="some_name" type="radio" value="3">  
            <label for="3">3</label><br>
        </form>

        <form v-else-if="questionType === 'text'" class="question-form question-form_type_text">
            <input class="input text" type="text">
        </form>

        <form v-else-if="questionType === 'time'" class="question-form question-form_type_time">
            <input class="input time" type="time">
        </form>

        <form v-else-if="questionType === 'tel'" class="question-form question-form_type_tel">
            <input class="input tel" type="tel" pattern="[0-9]{3}-[0-9]{2}-[0-9]{3}">
        </form>

    </div>

</template>

<script>
export default {
    props: {
        questionType: String
    }
}
</script>

<style>
    .question-card {
        background: #fff;
        border-radius: 20px;
        margin: 10px 0px;
        width: 100%;
        padding: 20px;
    }

    .textarea {
        resize: none;
    }
</style>