import streamlit as st

st.set_page_config(
    page_title="Sales Analytics Dashboard",
    layout="wide"
)

st.title("Sales Analytics Dashboard")

st.markdown(
    """
    This dashboard analyzes sales performance,
    customer behavior, products and revenue trends.
    """
)

col1, col2, col3, col4 = st.columns(4)

with col1:
    st.metric(
        "Revenue",
        "$1,250,000"
    )

with col2:
    st.metric(
        "Orders",
        "8,420"
    )

with col3:
    st.metric(
        "Profit",
        "$420,000"
    )

with col4:
    st.metric(
        "Growth",
        "75%"
    )